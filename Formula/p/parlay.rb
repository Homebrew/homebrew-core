class Parlay < Formula
  desc "Enrich SBOMs with data from third party services"
  homepage "https://github.com/snyk/parlay"
  url "https://github.com/snyk/parlay/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "ce6fe2050f1a04357c5efdd35ee62a9626aa61978d6b5153b281ad868e9b6e3c"
  license "Apache-2.0"
  head "https://github.com/snyk/parlay.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9500bdf0d7d002f14516ed724c1fafb1455c4eca2ea29acce67bfc05744c9f8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9500bdf0d7d002f14516ed724c1fafb1455c4eca2ea29acce67bfc05744c9f8f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9500bdf0d7d002f14516ed724c1fafb1455c4eca2ea29acce67bfc05744c9f8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a31b8e96a35dde70feb12cc350d8b9cf896b190f8960e95ec99d5421a887341"
    sha256 cellar: :any_skip_relocation, ventura:       "6a31b8e96a35dde70feb12cc350d8b9cf896b190f8960e95ec99d5421a887341"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffbc99d7d2c246b4ee5bfc0b0391f995c7692b72ce55edd67a818b975c58476e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/snyk/parlay/internal/commands.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/parlay --version")

    # test sbom data from https://github.com/snyk/parlay/blob/main/README.md?plain=1#L82
    (testpath/"sbom.spdx.json").write <<~JSON
      {
        "spdxVersion": "SPDX-2.3",
        "dataLicense": "CC0-1.0",
        "SPDXID": "SPDXRef-DOCUMENT",
        "name": "Example SPDX Document",
        "documentNamespace": "https://spdx.org/spdxdocs/example-spdx-document",
        "packages": [
          {
            "name": "concat-map",
            "SPDXID": "SPDXRef-7-concat-map-0.0.1",
            "versionInfo": "0.0.1",
            "downloadLocation": "NOASSERTION",
            "copyrightText": "NOASSERTION",
            "externalRefs": [
              {
                "referenceCategory": "PACKAGE-MANAGER",
                "referenceType": "purl",
                "referenceLocator": "pkg:npm/concat-map@0.0.1"
              }
            ]
          }
        ]
      }
    JSON

    # enrich the SBOM with ecosyste.ms data
    enriched_output = shell_output("#{bin}/parlay ecosystems enrich sbom.spdx.json")
    enriched_json = JSON.parse(enriched_output)

    package = enriched_json["packages"].first
    assert_equal "https://github.com/ljharb/concat-map", package["homepage"]
    assert_equal "MIT", package["licenseConcluded"]
    assert_equal "concatenative mapdashery", package["description"]
  end
end
