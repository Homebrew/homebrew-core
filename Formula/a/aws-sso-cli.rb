class AwsSsoCli < Formula
  desc "Securely manage AWS API credentials using AWS SSO"
  homepage "https://synfinatic.github.io/aws-sso-cli/"
  url "https://github.com/synfinatic/aws-sso-cli/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "3847945ad19bf9dddaea3a095095fb6e6425d95f8f1ca30d0a5a1f569aeaeaa3"
  license "GPL-3.0-only"
  head "https://github.com/synfinatic/aws-sso-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f47036c2b8442cebbf46a951d601851b01ce31e6c075dbb30f2d4a179bf8946e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa4bcaf928d65a51d381adeddc0c82a2f76c25b605dbbfb67474ac0622bdbc14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe0f94d12f81a718e14ca383c28f7bce59be609673b9af5f456731222d12c1c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ef27a3008e909b44d6db8c7c2c7bd75efee8eaedc18277dddc28273b4abe7e6"
    sha256 cellar: :any,                 arm64_linux:   "e83522c25cf6fe87164978ca43667cce6ad75dcba79cfeeb5ee4589c00f9834b"
    sha256 cellar: :any,                 x86_64_linux:  "b00d7b1911c9da19a42476f185d956f596663cf0d5e6f20df01d560ba3ae2b81"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -X main.Version=#{version}
      -X main.Buildinfos=#{time.iso8601}
      -X main.Tag=#{version}
      -X main.CommitID=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"aws-sso"), "./cmd/aws-sso"

    generate_completions_from_executable(bin/"aws-sso", "setup", "completions", "--source",
                                         shell_parameter_format: :arg)
  end

  test do
    assert_match "AWS SSO CLI Version #{version}", shell_output("#{bin}/aws-sso version")
    assert_match "no AWS SSO providers have been configured",
        shell_output("#{bin}/aws-sso --config /dev/null 2>&1", 1)
  end
end
