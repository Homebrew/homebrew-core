class Parlay < Formula
  desc "Enrich SBOMs with data from third party services"
  homepage "https://github.com/snyk/parlay"
  url "https://github.com/snyk/parlay/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "a903162d52c8e040affd3bf9790e1b5362e75b6f277dcb49ecfc628b84e6f658"
  license "Apache-2.0"
  head "https://github.com/snyk/parlay.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "25f9163845ce736478f8380e32daa714c856965cf5e7641fb41c9f3d9b24ebff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25f9163845ce736478f8380e32daa714c856965cf5e7641fb41c9f3d9b24ebff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25f9163845ce736478f8380e32daa714c856965cf5e7641fb41c9f3d9b24ebff"
    sha256 cellar: :any_skip_relocation, sonoma:        "1445b085620fd14eb860108e8cab624d6347f9a590194fad409d29a471c59601"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "584682d6b1bb31f97fafedb479b6999f8a2de0c9b42160f4c8a005b8859ea94b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72ea01111692233718e79a59d60fbe5b5cf9b06abe1b41751209818073dad060"
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
