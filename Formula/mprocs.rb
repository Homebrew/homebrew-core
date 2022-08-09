class Mprocs < Formula
  desc "Run multiple commands in parallel"
  homepage "https://github.com/pvolok/mprocs"
  url "https://github.com/pvolok/mprocs/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "9fa61b31fa6b6eeb3ccc018d806b9e672bb66d63c581f15ba8f409f32bca7742"
  license "MIT"
  head "https://github.com/pvolok/mprocs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5eca074c02ad2c8044d3516409340ca0a2b2b626446dc482bb0d8f7f537fe09b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7194e21bf2dca29fb88f433a5cb8dc9ad290be499a00c4e0675109d7bfc87f2d"
    sha256 cellar: :any_skip_relocation, monterey:       "da43f73338f89b4aa65c32ef55b57cf8b44393f63c0a117652701bc49712a5dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "ecf8c056a217f7f57c5efa55bdcf939cc528b464c47e5b95567903fd94c97dd0"
    sha256 cellar: :any_skip_relocation, catalina:       "2ffac7a9f5ad5fb2c59df1655a904e42fadc63493fb7c38a308387628ac54742"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b46632dd3b58e0fb98200bba1fc8cdaf56ab6dc21debb6c3e3c586adfe537dd1"
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
