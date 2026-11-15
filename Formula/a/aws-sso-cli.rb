class AwsSsoCli < Formula
  desc "Securely manage AWS API credentials using AWS SSO"
  homepage "https://synfinatic.github.io/aws-sso-cli/"
  url "https://github.com/synfinatic/aws-sso-cli/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "1c368a61e46c820945386d0960bac01d26634104e6d24c424abee820daee91b5"
  license "GPL-3.0-only"
  head "https://github.com/synfinatic/aws-sso-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e0784e7c92a218c5b5a0890fc43f933d694b0327d38f0a78b4a6c1ca03252d55"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "603963fdc881ef9c9cb26f8908cb84957a0c34fb734efe285bb803b4cea6759b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f4759a5e0ec82adcbc36b96be72a7a17db02ea006c22da2b172622c21e2be9a1"
    sha256 cellar: :any,                 arm64_linux:       "051d03083e6cc25cdb40760ef3fb23ab11643559712708269c8ad19299f1d952"
    sha256 cellar: :any,                 x86_64_linux:      "f33492ee3dc68d481cfff1ec760a69f0913e652a9364b0970e694a7db4f363fd"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
