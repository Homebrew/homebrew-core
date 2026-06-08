class AwsSsoCli < Formula
  desc "Securely manage AWS API credentials using AWS SSO"
  homepage "https://synfinatic.github.io/aws-sso-cli/"
  url "https://github.com/synfinatic/aws-sso-cli/archive/refs/tags/v2.2.4.tar.gz"
  sha256 "4dbc9e3394652d6f07d8544c10d2d3f8e147fb647493dd3b3a87da34061ee7c6"
  license "GPL-3.0-only"
  head "https://github.com/synfinatic/aws-sso-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "214046d701961185450171fbb622077a23fc22c408396b50fb102029eb1f7907"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53cd25b08b41c0aee8e406363fce502486c0c21abe880d9aeef7375f91eca903"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9853df75dfab00191cdbbe55412a0aa1dfbc2172527fdf92f0322200f8ed20e"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d61c9ee7cc6e8045a2945dbab3ac485ed9e7b905e324faa19ac3cd1fb6644c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf28ca6a0d5cf543cc81bc82a0289671ff08ade4a9709378ee0b4631892fc3ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e806ede43367e51127afeaaa25fc44dc325e42e032a1aece5ae2448a958cfa5"
  end

  depends_on "go" => :build

  def install
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
