class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://www.speakeasy.com"
  url "https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.26.3.tar.gz"
  sha256 "af4dfb380ec5d8845f979df9889d77368aee4cbeac68791b4cf4522bed81a5c1"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2c15de82e8f965396a76e1c99bf39e994011b432a1ce418eee0b941e007ad3ea"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2c15de82e8f965396a76e1c99bf39e994011b432a1ce418eee0b941e007ad3ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2c15de82e8f965396a76e1c99bf39e994011b432a1ce418eee0b941e007ad3ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1fd0db6fa1a654e1d7980fd26f5b0d528199d1b6496e723ba776a240d1faabc6"
    sha256 cellar: :any,                 x86_64_linux:      "725b027d2b765126ecf8bd0d2aa8e2de473ea4982c3c8a87998682c16ea05d3d"
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
