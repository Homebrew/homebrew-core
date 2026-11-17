class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://www.speakeasy.com"
  url "https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.27.0.tar.gz"
  sha256 "00744adae37a51bfa30f7a63ea8c1e47368897a5af7095de435fd4808d948307"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d470babcc445c0a920ff6465b22e96bc530092eb5e167992104ef5346962aee2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d470babcc445c0a920ff6465b22e96bc530092eb5e167992104ef5346962aee2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d470babcc445c0a920ff6465b22e96bc530092eb5e167992104ef5346962aee2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1534d1bdb778ff3e382671aafd5079aacc41023ff3e2042e6d5f205819b32bb8"
    sha256 cellar: :any,                 x86_64_linux:      "4eaaee7c2c095650773ccbbb4694624ac98bad138ce27445a07f528146ac3de9"
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
