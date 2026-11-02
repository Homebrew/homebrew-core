class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://www.speakeasy.com"
  url "https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.26.3.tar.gz"
  sha256 "af4dfb380ec5d8845f979df9889d77368aee4cbeac68791b4cf4522bed81a5c1"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f67628596367bc20f47027f3dcb3cecb2a7da18d3ec523414b54751fcb22894c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f67628596367bc20f47027f3dcb3cecb2a7da18d3ec523414b54751fcb22894c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f67628596367bc20f47027f3dcb3cecb2a7da18d3ec523414b54751fcb22894c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3296b95c3070a10033498bbcf241aed2c2d7071365f3461f8f6dab5315ddcf57"
    sha256 cellar: :any,                 x86_64_linux:      "18638443ece32f7d8719779f6dc0614bba250fb24d9176263b412282adc66753"
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
