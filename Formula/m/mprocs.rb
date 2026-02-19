class Mprocs < Formula
  desc "Run multiple commands in parallel"
  homepage "https://github.com/pvolok/mprocs"
  url "https://github.com/pvolok/mprocs/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "e0e91097399b751df42558c3717e6be130bfd523612c772dd1e3f9070eddbc5e"
  license "MIT"
  head "https://github.com/pvolok/mprocs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8807d84fc02137877db54f8d343cb3c409e7b12a51776ac1e68e96cb819c85f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fd53ab3f3a4b256785cb01f955cbf59d7d166e92b14a286b8dcea72ce635b19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f29cca7f593224fcfebeae7a0a37b16554901292bb58583408d2194e85ee03b"
    sha256 cellar: :any_skip_relocation, sonoma:        "98b807d712c243c55b14747ec52c44cd9a9c5f1c988eff37a5c0e926fe4158f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a14fe395a18c6debf96d1ba97fa8c8fbd38261ffba26486bdb48b6fcf4ccbc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "461942199bc0f9799faed2ae5583a14d7e44e277efa8739032fbe882149730e2"
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
