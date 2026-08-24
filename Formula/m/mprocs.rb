class Mprocs < Formula
  desc "Run multiple commands in parallel"
  homepage "https://github.com/pvolok/dekit"
  url "https://github.com/pvolok/dekit/archive/refs/tags/v0.9.6.tar.gz"
  sha256 "294fa02bfec7c73bc29448c55497ac46deda8b82bec259e492c51cfb67330c2d"
  license "MIT"
  head "https://github.com/pvolok/dekit.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e2ee1311391c3237cf1566c56de41d128f0e493bb190e4ef9fc99588f88986b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24838ae6104b6c567d67de62b5c251c7a1f087d9d3949d245f49b8d3aa26dfc7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a394ba6f897d91c7d0781481461bb652b88430a44deec1b13b96ffbf6b6b18c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "42271d967e074dfbfc6815c4003abedec74f7b43f98be40687718992036fd65d"
    sha256 cellar: :any,                 arm64_linux:   "63568281004346602e185ebfb80fcd7cba9c33cbf01c4e4b2648551e23fdb22b"
    sha256 cellar: :any,                 x86_64_linux:  "5255678add044d7886321bfb2fe6ecb02997c32bbbfd3e6cf38cf8471c9b4982"
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
