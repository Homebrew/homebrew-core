class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://github.com/speakeasy-api/openapi"
  url "https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.23.1.tar.gz"
  sha256 "de17d378f2b8406f473668554f35ad40004abf89d2535f11affe748178fe2ecd"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55063076104cf6813a96bb78c57134474d2681e62735264f3936fed1d3465d6c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55063076104cf6813a96bb78c57134474d2681e62735264f3936fed1d3465d6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55063076104cf6813a96bb78c57134474d2681e62735264f3936fed1d3465d6c"
    sha256 cellar: :any_skip_relocation, sonoma:        "613b649a05f74e41ab4cd5bf132ef7e48919f10c4f152064f25cbb2416755989"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "884da5b4cc4fcd453ae3f5db3241a6a58030819d3248066af48e7988c03118cb"
    sha256 cellar: :any,                 x86_64_linux:  "a56257beb2b1a3bd97a53db039b749a5ec0630360d76d6ea2ca430a9c18942c1"
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
