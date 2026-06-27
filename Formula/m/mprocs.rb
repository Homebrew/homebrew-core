class Mprocs < Formula
  desc "Run multiple commands in parallel"
  homepage "https://github.com/pvolok/mprocs"
  url "https://github.com/pvolok/mprocs/archive/refs/tags/v0.9.6.tar.gz"
  sha256 "62488726fc5539772a41863428026f51b4c03d5ac27c56191775e5a721ae90c2"
  license "MIT"
  head "https://github.com/pvolok/mprocs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f394b0b592afda66436defbe72b0995a7471ad92bb8839d34158f1d2fa570854"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "526b3adb479f79436d72e7ad163fb596124e4d57d7ef528b55241b43003ca6fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f59490acf88577eb898b54d1eb234f8da47d04e53ef3cfe031b1ad593613cf2"
    sha256 cellar: :any_skip_relocation, sonoma:        "23c84d9dac182c973b49e4021347ecf3272930b098aac8d0ed79d6dd2b2852b7"
    sha256 cellar: :any,                 arm64_linux:   "f8c9637453f3b78582dca1d2d580a71ea247b99e282539581cce5524de6a36a1"
    sha256 cellar: :any,                 x86_64_linux:  "35aff5529f3a2c7e5263a59046edd602cdaa77648eac82cea5d8c2ba22009936"
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
