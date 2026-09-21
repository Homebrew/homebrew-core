class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://www.speakeasy.com"
  url "https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.25.2.tar.gz"
  sha256 "e8a07aed1e46d766f72494e85c69066f23dfc1e7d6b56ec32b4bf66c40d7443b"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "661d6ba9a24532a484cc6da642418e6e1a2e9bb8829031bbff47d08d13741391"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "661d6ba9a24532a484cc6da642418e6e1a2e9bb8829031bbff47d08d13741391"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "661d6ba9a24532a484cc6da642418e6e1a2e9bb8829031bbff47d08d13741391"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2c25e87f5a2a7a0c32a3e64c267e146669c5f6ed0e50323df839d993429de3b0"
    sha256 cellar: :any,                 x86_64_linux:      "fff031ca707dd86212b8179cc289ec783e0ac6e7a4996154ba3936881ae90938"
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
