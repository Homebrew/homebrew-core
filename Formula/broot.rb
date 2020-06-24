class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot"
  url "https://github.com/Canop/broot/archive/v0.17.0.tar.gz"
  sha256 "b970748f34536c73f97cd1351768f9067a9d954be885ab65146378e0b0f20089"
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d3aeba5c1c18f02a66586ba27fae3212abe67449a7ef1d92d35694f29410c1b6" => :catalina
    sha256 "141dda66b01eda3bbadd12fea67b325877e0e7abcc25aeb8b939605e7a49e5b6" => :mojave
    sha256 "4870870932295b238faf00887d090351326ce71df2bcb6ae4a7e0059739ae1bc" => :high_sierra
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    assert_match "A tree explorer and a customizable launcher", shell_output("#{bin}/broot --help 2>&1")

    require "pty"
    require "io/console"
    PTY.spawn(bin/"broot", "--cmd", ":pt", "--no-style", "--out", testpath/"output.txt", :err => :out) do |r, w, pid|
      r.winsize = [20, 80] # broot dependency termimad requires width > 2
      w.write "n\r"
      assert_match "New Configuration file written in", r.read
      Process.wait(pid)
    end
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
