class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "a5e51d6dff3fdbda740de0aa85257585bbd18c1ab3918fcd6d164c99282c5324"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "97eefa05ee09285f09b6f5dcf008527d835a25f19f3b2c7f6023bba64c0a138d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "790709af96e4285bcc18ec606f7ac671cfdb076fb5ec784818e86213f5b04aca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3492cf810e28dbf3771e4d09343d5b4707532a642d3bcbf2639088cb0d285f67"
    sha256 cellar: :any_skip_relocation, sonoma:         "5bf6a266173764d26246cb9ae55b84b01c47b271a6fb6910b647f1b983751cfc"
    sha256 cellar: :any_skip_relocation, ventura:        "62983a81193e642bfb1c0765900e0c96afaa1c1f82171b227df0b2101aeedb64"
    sha256 cellar: :any_skip_relocation, monterey:       "47b8b10db44fba7b952e0990485b9563da8fa4655390579919aa79004a550661"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1800c24e2b160aafbaf0b40953f67cd69b0ffc9e57f2b54fa19d6276521f3fe7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/livekit-cli"
  end

  test do
    output = shell_output("#{bin}/livekit-cli create-token --list --api-key key --api-secret secret")
    assert output.start_with?("valid for (mins):  5")
    assert_match "livekit-cli version #{version}", shell_output("#{bin}/livekit-cli --version")
  end
end
