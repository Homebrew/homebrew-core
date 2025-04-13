class Parlay < Formula
  desc "Enrich SBOMs with data from third party services"
  homepage "https://github.com/snyk/parlay"
  url "https://github.com/snyk/parlay/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "6eccd4b992d54c6066909b1a891ed9f6f5de4fbb43015edba5b0c1c35b2cb4e5"
  license "Apache-2.0"
  head "https://github.com/snyk/parlay.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "456169da5e7f9bfdb41468ca3ef6da4cc0633bd53223dda865131da73eabf013"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "456169da5e7f9bfdb41468ca3ef6da4cc0633bd53223dda865131da73eabf013"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "456169da5e7f9bfdb41468ca3ef6da4cc0633bd53223dda865131da73eabf013"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f7f8ab6b8b264968c52d0406f6e076dcf4fa9708f4e5cb193dfe197633a3739"
    sha256 cellar: :any_skip_relocation, ventura:       "8f7f8ab6b8b264968c52d0406f6e076dcf4fa9708f4e5cb193dfe197633a3739"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1daa00909693aa418948b5433d7e1a484e78572c7043a536f98a70c4508a4780"
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
