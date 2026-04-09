class Mprocs < Formula
  desc "Run multiple commands in parallel"
  homepage "https://github.com/pvolok/mprocs"
  url "https://github.com/pvolok/mprocs/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "1eefc5346f3c8b24ee6bf74582312fc61284ea54d4d384a4a8226d4b75ddb98b"
  license "MIT"
  head "https://github.com/pvolok/mprocs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c869339d62813971e67d8f884c12fedd6a97e32a2abdd3ca4857fca92eb6b35a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98308e0626104774fc560cba95bdc6508ccd618ec195d3b8433aeeccc8401837"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1af5c10c627a687a41443f8d7d0a116eea05c23bb03dcf11ea21114afd060ee6"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9ac96d9aa27c7e627d2e5a7860670c6114be2e879b8c545a8768fc588b4919e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "719870a0ac991acfa4730e1ac474e7c2dab96ee3fbfa51273d0d9463076aa0f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "238de7c5d39519ea7b25cd5848d74698600ed8ff18a01502fd8b39ba8bb21b55"
  end

  depends_on "rust" => :build

  uses_from_macos "python" => :build # required by the xcb crate

  on_linux do
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "src")
  end

  test do
    require "pty"

    begin
      r, w, pid = PTY.spawn("#{bin}/mprocs 'echo hello mprocs'")
      r.winsize = [80, 30]
      sleep 1
      w.write "q"
      assert_match "hello mprocs", r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  ensure
    Process.kill("TERM", pid)
  end
end
