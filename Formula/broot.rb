class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v0.20.2.tar.gz"
  sha256 "8398e8147c3d476010264a007ec00d0503a88b6b7382421a8f912d38a3f0afbc"
  license "MIT"
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cc00a78f6b83398b4de07ada8652848dd5df2ebb07d565a6933a0343fa59c9b8" => :catalina
    sha256 "28e7e801fa327985d7770c3e026dedba2ad66c10715bdf8a2044749fff4ab9df" => :mojave
    sha256 "ede7b52a79cf9154e2d145629a2fc41e1479a9a1c59c12b158adc7711c010f8f" => :high_sierra
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "A tree explorer and a customizable launcher", shell_output("#{bin}/broot --help 2>&1")

    require "pty"
    require "io/console"
    PTY.spawn(bin/"broot", "--cmd", ":pt", "--no-style", "--out", testpath/"output.txt", err: :out) do |r, w, pid|
      r.winsize = [20, 80] # broot dependency termimad requires width > 2
      w.write "n\r"
      assert_match "New Configuration file written in", r.read
      Process.wait(pid)
    end
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
