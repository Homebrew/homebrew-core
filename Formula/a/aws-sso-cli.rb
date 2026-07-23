class AwsSsoCli < Formula
  desc "Securely manage AWS API credentials using AWS SSO"
  homepage "https://synfinatic.github.io/aws-sso-cli/"
  url "https://github.com/synfinatic/aws-sso-cli/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "14caf8315a715758da53819be45e6842f89383bcf9fd8abe3a68ec3591cde646"
  license "GPL-3.0-only"
  head "https://github.com/synfinatic/aws-sso-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "983e6acd0676d92ac29fc9f436854e5a6df9dffc0e0285588808e320abb1eef3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d308ace5364c869777498c1827051c4e345f1ae9a25f4eeec25d0b2d851297db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69e526088ee6df1e918fcd7e3c100ca7e3b68b43438ac2130d448e4898ae0549"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9343a1ada1671d7502e0de482d12e075c0c784cb6a568bae42e839c0cd28d1d"
    sha256 cellar: :any,                 arm64_linux:   "c867965c6d0c219f2b0386e5d7cecaed3bd84e86c6e0dfdb7f428be2b116cd69"
    sha256 cellar: :any,                 x86_64_linux:  "8699fb89ab204a3494ab305136e43b09360bd3147977f840b839578ae32c6dcd"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
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
