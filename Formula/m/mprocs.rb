class Mprocs < Formula
  desc "Run multiple commands in parallel"
  homepage "https://github.com/pvolok/dekit"
  url "https://github.com/pvolok/dekit/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "573e9d9ce12d2ce9236fa8979aecdd1edd26bab0ab99f1268c44d7f9b225d345"
  license "MIT"
  head "https://github.com/pvolok/dekit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "302d29cb65557f004944b837b0f2b8a6cc3c693ee5ecb0a69f8b42d79ec32388"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "36e5c20a22418b6447c453231f609c4dd4606c8556a828c03816c4a9fbb14589"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d5851fbac70ff544d68a19680e5cf39260cb1993c2c328582c7a8e9c4d8e3e91"
    sha256 cellar: :any,                 arm64_linux:       "1120730bd84a80d2d8ed1a6292e14f357fff6993ee60240d3c0402c36e03768f"
    sha256 cellar: :any,                 x86_64_linux:      "8da2a4bbb75beb329e214e2cc1af3f6f3bff175028756e8663259b361d2f176a"
  end

  depends_on "rust" => :build

  uses_from_macos "python" => :build # required by the xcb crate

  on_linux do
    depends_on "libxcb"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "src")
  end

  test do
    require "pty"

    begin
      r, w, pid = PTY.spawn("#{bin}/dekit 'echo hello mprocs'")
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
