class Mprocs < Formula
  desc "Run multiple commands in parallel"
  homepage "https://github.com/pvolok/mprocs"
  url "https://github.com/pvolok/mprocs/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "4bee11e6baf912dda3e28b6a94a28d1f323a28ab35b672029e6ec6b175910787"
  license "MIT"
  head "https://github.com/pvolok/mprocs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "126f7a6a91c1517731cf9dec8895e66b1ed7ac1e5c064b3137187fcc7263f1de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce625145e06d5a804675c5471d7e6182822d35568d85cbc7284b3e5843082b78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cae3348cf54183705dc2ab8961c277bb20240db7ade123771c4feaf0a39e453a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a921efe63cb35f57c7a60635c9d7d366c53230aefd6d71e6681e8841223b0ac6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d75ea976ee3f856b00631758c0cdb49f93b647f3e08de91cb37edaefde76c07d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4567e7036d0f95c0dc14dd2528344ad092b94f0de3c54e19f61c33b1a16bde97"
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
