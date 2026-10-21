class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://www.speakeasy.com"
  url "https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.26.0.tar.gz"
  sha256 "6811b537fcc4962038f8fcc6a952b783dd6c8fa44526970abf2ca89339afcc3b"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "87433abe33ff8855c821d4d5fea15098618728d212d7722f73f539350010a06d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "87433abe33ff8855c821d4d5fea15098618728d212d7722f73f539350010a06d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "87433abe33ff8855c821d4d5fea15098618728d212d7722f73f539350010a06d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "59625bece51f93de6feab095eb2afbce974179a50f999fee6915af7d68adaf49"
    sha256 cellar: :any,                 x86_64_linux:      "62c3de9d9c62aada078559080c1aded0183dfd4c6a4ba1e9a0fdf013af2c7521"
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
