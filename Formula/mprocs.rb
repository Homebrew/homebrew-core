class Mprocs < Formula
  desc "Run multiple commands in parallel"
  homepage "https://github.com/pvolok/mprocs"
  url "https://github.com/pvolok/mprocs/archive/refs/tags/v0.6.4.tar.gz"
  sha256 "7fdb5f3f8baaa82ccb7bf2193a7b843027cb133824a99475226524c105255077"
  license "MIT"
  head "https://github.com/pvolok/mprocs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0eb52d211cb3e815fde72ac095e47d6ed6d9c0c4144521a2a8186d60a978b45e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "809917011f4d7b325f47e690f18ad5ebc929e69057e8ff9bf8e4bd5c3d13d2d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d96fa9177201787519d810a8cef0dfa489c40991ef93f472f7437ba3400c8081"
    sha256 cellar: :any_skip_relocation, ventura:        "d9faadb723f373b8ffd992a5282d1da8171130587166e2831e2cdc1ce44b831a"
    sha256 cellar: :any_skip_relocation, monterey:       "1189819af1ec7c13b6c23a66d0964a123a2f46c3adeb82b5ae4a6784c344cace"
    sha256 cellar: :any_skip_relocation, big_sur:        "944c5e0b1f910f4202eb334e8d0f5152d5c791c10241d57000f4a7095ed68a04"
    sha256 cellar: :any_skip_relocation, catalina:       "21334450af9a4872263142344fe6451bc9d299fb2a8df5c0ca99b6d15642660c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "010993dcf1f72fcdaf8ac26ae55c6f2ae3de15ac1aab7ec6a7012f69133b52e8"
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
