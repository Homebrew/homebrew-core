class Mprocs < Formula
  desc "Run multiple commands in parallel"
  homepage "https://github.com/pvolok/mprocs"
  url "https://github.com/pvolok/mprocs/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "da00ed6c693b9282b2553f69cee05eed039b1b3e948620c20b5d8ca6b2542aba"
  license "MIT"
  head "https://github.com/pvolok/mprocs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a6a16b22ae3a23bf0f6ed801ea04d788a4403d2c5d333f36df6cba762100346"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb8d5528980d10e5323792524a8d0b5904f7587541fb57c42e39e72c4e861e89"
    sha256 cellar: :any_skip_relocation, monterey:       "9c300454d04d824541f12a7b5a9ea9575c3c04ce42fbd759e16643e01876379c"
    sha256 cellar: :any_skip_relocation, big_sur:        "2cd7cb514e27ae9666ad1b3717b8dee9e0474b101931abd7afd1e4f19f3f1d5b"
    sha256 cellar: :any_skip_relocation, catalina:       "8f814fe445ce0fce99328f49847e5c81f8ebcd55ae05d6386d9db3e461ae282b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac4b487b36e5c774f8cdd3ce125c5c1e656544cb85e7c000850dfad6e60d5d69"
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
