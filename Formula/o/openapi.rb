class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://github.com/speakeasy-api/openapi"
  url "https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "4b160d3a9605da19d36b09254f356f41aeb86c710d481e214d8b22ed2e7812e3"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cac8353fccc65f37df205a390a914971e4f0370be4d8689915f38bb0ef8010c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cac8353fccc65f37df205a390a914971e4f0370be4d8689915f38bb0ef8010c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cac8353fccc65f37df205a390a914971e4f0370be4d8689915f38bb0ef8010c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "916e1958c2d8e77cbfe67c0de5d5159c979c963f320c2f2c6e8220ed15601dd0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "199b357291717fda2480e0f36d3f0e984b67cb13e27d34f5b4237b6f8e7eebac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a49a756b727275b32986cb55d7741b634fe5ec94ebb75ad339916ed8bb4f322"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/openapi"

    generate_completions_from_executable(bin/"openapi", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openapi --version")

    system bin/"openapi", "spec", "bootstrap", "test-api.yaml"
    assert_path_exists testpath/"test-api.yaml"

    system bin/"openapi", "spec", "validate", "test-api.yaml"
  end
end
