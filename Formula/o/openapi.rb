class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://www.speakeasy.com"
  url "https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.26.4.tar.gz"
  sha256 "6dc210704c40b5d94888b4e0a027a5da4cb3da4df139aae3ad37526c07ef6665"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bbcd6621eb20ba99e362b62424a878dce29625ed0d3522a9539c24014b6c13a4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bbcd6621eb20ba99e362b62424a878dce29625ed0d3522a9539c24014b6c13a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bbcd6621eb20ba99e362b62424a878dce29625ed0d3522a9539c24014b6c13a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c40f72ca3ef49c349c413b18d509f45e0a3887de1b3dff032e0fff54fb8a9474"
    sha256 cellar: :any,                 x86_64_linux:      "42a3ac1582aab1e0cb7436536e02d5642c253d7f0d05a4741f4f0ad86cab38d7"
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
