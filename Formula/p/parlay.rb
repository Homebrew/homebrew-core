class Parlay < Formula
  desc "Enrich SBOMs with data from third party services"
  homepage "https://github.com/snyk/parlay"
  url "https://github.com/snyk/parlay/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "b06ae57019144bdec330747dc2593bf07976acab06990682731205a8ce819a72"
  license "Apache-2.0"
  head "https://github.com/snyk/parlay.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "96dbbf77cb5449ad774bcbcc89b834ba15e49298af96ff0634fa6624b3a2a0dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9068e1250bb228d85ba7aded90418b57b27dab63a8d68cedf760d281b2f4c31d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9068e1250bb228d85ba7aded90418b57b27dab63a8d68cedf760d281b2f4c31d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9068e1250bb228d85ba7aded90418b57b27dab63a8d68cedf760d281b2f4c31d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae13e29edb7eb752c6588b2fec0a0fb3881d56e1f44b2d711d71923d44641cf3"
    sha256 cellar: :any_skip_relocation, ventura:       "ae13e29edb7eb752c6588b2fec0a0fb3881d56e1f44b2d711d71923d44641cf3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a61328e36579dbc0e2128d755821cf20f0a36f28e7ec065d969c4794c4430cbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0bd178923029b114ce65a76c9880b2c7c137fb8e2a125f103f61f9a8b280d45"
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
