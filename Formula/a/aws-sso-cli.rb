class AwsSsoCli < Formula
  desc "Securely manage AWS API credentials using AWS SSO"
  homepage "https://synfinatic.github.io/aws-sso-cli/"
  url "https://github.com/synfinatic/aws-sso-cli/archive/refs/tags/v2.3.4.tar.gz"
  sha256 "b52ef033fa140d26689234f62e7112d79f5bc5778c95ef159d15ad7164f283d6"
  license "GPL-3.0-only"
  head "https://github.com/synfinatic/aws-sso-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ab8ab9eea5f95373b1d07d1fde194d7a74c278fb8a38365b373fbed3695a36a0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0d0966c8a46e8a66e48be41f3b2a19cae51dcbb6ea0da55a027cae59cc0dcfa1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "22566d49e38cd86499510354b4f79181dfeacc591531691cd0af517bebb47034"
    sha256 cellar: :any,                 arm64_linux:       "5820007464a52409907202d6173132de1afe61aa08a6c5119b555eeb33a50dfe"
    sha256 cellar: :any,                 x86_64_linux:      "c853ceb195872cf1e47c31752b4dd2afd0d99a33095617e71b23ec9c38a50ce4"
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
