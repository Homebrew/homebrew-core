class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://github.com/speakeasy-api/openapi"
  url "https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "2eed32b7610ce6a61c2acde863b92034838929f8ea91e270655d450ffd768aed"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83a3c604a163c19dc6f47dcaea97927b85f208fa844263f3b28437a8b8d927ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83a3c604a163c19dc6f47dcaea97927b85f208fa844263f3b28437a8b8d927ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83a3c604a163c19dc6f47dcaea97927b85f208fa844263f3b28437a8b8d927ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a9958a75c04009873883fb391fa3a67be803283b414d45651b3eb5882e8ba2d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d806bc4c9bae99c031f1b5439f356d8c0ac29a6eb980ab9df516763c4e721cd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd108566e52abf19b3388fd308153267cdc470e0b5bd9497af3fb3121e46f15a"
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
