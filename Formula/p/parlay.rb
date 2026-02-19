class Parlay < Formula
  desc "Enrich SBOMs with data from third party services"
  homepage "https://github.com/snyk/parlay"
  url "https://github.com/snyk/parlay/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "c1f9eaa073b6c958a0722b145fcea9fa3579c9b5552f3359d86f91917441253b"
  license "Apache-2.0"
  head "https://github.com/snyk/parlay.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd292a2313af1696d0a9bb418fb116f684a785f0238857b9ac9d327f1c88cf87"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd292a2313af1696d0a9bb418fb116f684a785f0238857b9ac9d327f1c88cf87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd292a2313af1696d0a9bb418fb116f684a785f0238857b9ac9d327f1c88cf87"
    sha256 cellar: :any_skip_relocation, sonoma:        "317fc1de29e6aaeca917a94d65e1205415aaac971186de78e6362ce43c93d0ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb4424ae51442b6843720f50357049f8bc1d5ce3c3ca12fb303a424a08a15f24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de4c7f7596f1a82cfe2db2db8164285cc2619006e00b9ce5521ca8bfe22a060c"
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
    assert_equal "https://github.com/ljharb/concat-map#readme", package["homepage"]
    assert_equal "MIT", package["licenseConcluded"]
    assert_equal "concatenative mapdashery", package["description"]
  end
end
