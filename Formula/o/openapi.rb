class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://www.speakeasy.com"
  url "https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.26.5.tar.gz"
  sha256 "3476076240be6696a82b0a30ee151c6fe7170db37c8688bfa521af979d9b6968"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e7b7d8dea5fa428fde5da5fc9bfc2730589af38b3334463f308f30f968ab415d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e7b7d8dea5fa428fde5da5fc9bfc2730589af38b3334463f308f30f968ab415d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e7b7d8dea5fa428fde5da5fc9bfc2730589af38b3334463f308f30f968ab415d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4605aca5664d5a1a6d4bcd74c05d33e5000a6be26042cfdc841e66c77f02d203"
    sha256 cellar: :any,                 x86_64_linux:      "9a1c9e876109fbe37b6b53f9e033a4ff7a99c38a0af497f2b9e29872024a33db"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/openapi"

    generate_completions_from_executable(bin/"openapi", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openapi --version")

    system bin/"openapi", "spec", "bootstrap", "test-api.yaml"
    assert_path_exists testpath/"test-api.yaml"

    system bin/"openapi", "spec", "validate", "test-api.yaml"
  end
end
