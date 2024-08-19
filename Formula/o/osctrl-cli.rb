class OsctrlCli < Formula
  desc "Fast and efficient osquery management"
  homepage "https://osctrl.net"
  url "https://github.com/jmpsec/osctrl/archive/refs/tags/v0.3.8.tar.gz"
  sha256 "03c2c3c79357b646628458fea9344f24c6ba75bc28301eb535022f73c752b103"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "699da64670a658cf1d286c32477d4634f665d87b80ac484a5639c53414abf0a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "699da64670a658cf1d286c32477d4634f665d87b80ac484a5639c53414abf0a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "699da64670a658cf1d286c32477d4634f665d87b80ac484a5639c53414abf0a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "0943d1f8d9df225823b2bfcce6b3fa1d29e7ff6ec6668a4303900c42f351ef40"
    sha256 cellar: :any_skip_relocation, ventura:        "0943d1f8d9df225823b2bfcce6b3fa1d29e7ff6ec6668a4303900c42f351ef40"
    sha256 cellar: :any_skip_relocation, monterey:       "0943d1f8d9df225823b2bfcce6b3fa1d29e7ff6ec6668a4303900c42f351ef40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19fb2dcb44b855b03dea3e943b6bfbc6dfb399590d8a1b06fad84b4bd3433885"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/osctrl-cli --version")

    output = shell_output("#{bin}/osctrl-cli check-db 2>&1", 1)
    assert_match "Failed to execute - Failed to create backend", output
  end
end
