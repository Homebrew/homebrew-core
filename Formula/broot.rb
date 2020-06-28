class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot"
  url "https://github.com/Canop/broot/archive/v0.18.1.tar.gz"
  sha256 "8ce229474bc59902cbe09d4cfa2a9bc4b3c4293a73fa51b37032927083636cd4"
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7d03e8c94843168ea31b85b38a62365da9aa4c1783380013c16e026cb8399e85" => :catalina
    sha256 "8d26eb7cdd53aebac3fe6183cc171620e217490e4e669cee1746f32170a84248" => :mojave
    sha256 "d5c76a6ca27757b4d4131424d00c0d81cc24214ca9fab4b43de2bfd91d0b68e5" => :high_sierra
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
