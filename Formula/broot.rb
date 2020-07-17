class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot"
  url "https://github.com/Canop/broot/archive/v0.19.1.tar.gz"
  sha256 "10e4878fb4a020901d98e30b002b1409b4deb53202ceff51d5af7901374388c9"
  license "MIT"
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6cface90edb4deb369b709e877db5f4b4cb9da5b1126c3bdd0a2608fa9fe78b2" => :catalina
    sha256 "2d1bb52527b5b3ccca43b7a78b29f795eea879194af3136e149a054a92ab2a53" => :mojave
    sha256 "9d33aafd60c07462a88f689c850ec3f9090d19492d20b8790386be3945b43470" => :high_sierra
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
    PTY.spawn(bin/"broot", "--cmd", ":pt", "--no-style", "--out", testpath/"output.txt", :err => :out) do |r, w, pid|
      r.winsize = [20, 80] # broot dependency termimad requires width > 2
      w.write "n\r"
      assert_match "New Configuration file written in", r.read
      Process.wait(pid)
    end
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
