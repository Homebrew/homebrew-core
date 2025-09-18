class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://github.com/speakeasy-api/openapi"
  url "https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "06ee551a1835ea19f55fb499727bcf436a8b88e12aeedf4104b7fbdbe72be502"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc1035a42c516259459aa33c2279f90ca27087fd721f54c4ad9f79def74dd73f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc1035a42c516259459aa33c2279f90ca27087fd721f54c4ad9f79def74dd73f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc1035a42c516259459aa33c2279f90ca27087fd721f54c4ad9f79def74dd73f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e689a7600b3f20e414e5c5fc9529f501572d9df3f6708d4f0851ec6ff4feeeb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "289a30853567916bc55b23a9fdc8e73cbf0a9cce9cb81d318057296d0fab571b"
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

    generate_completions_from_executable(bin/"openapi", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openapi --version")

    system bin/"openapi", "spec", "bootstrap", "test-api.yaml"
    assert_path_exists testpath/"test-api.yaml"

    system bin/"openapi", "spec", "validate", "test-api.yaml"
  end
end
