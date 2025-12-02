class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://github.com/speakeasy-api/openapi"
  url "https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.11.1.tar.gz"
  sha256 "86ef12cd83fb922b322cd8159b1cf3abd1642ef8b1f7a7155a703101e6e7fb69"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad9de48f866843dafef4821b35239f5d3d0b2c4f3875f85508fe9ae7b959490d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad9de48f866843dafef4821b35239f5d3d0b2c4f3875f85508fe9ae7b959490d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad9de48f866843dafef4821b35239f5d3d0b2c4f3875f85508fe9ae7b959490d"
    sha256 cellar: :any_skip_relocation, sonoma:        "af898c1df6856b1cd581e87225665cc34857f5a3e5a5d91d28540150ae9b67bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9d5bda5d33e3da510c062e4c16428caae2a73c916ec1db329cb10a378f04d33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d50b2eac978fcd95a17f84e570f691a9ceb2b833eef76add4ae06cb178dda23"
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
