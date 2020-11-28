class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.0.7.tar.gz"
  sha256 "48988ef94993a6c8f5a80cb09813b729d8e149380dcba5e5878ecc7fd3617cc1"
  license "MIT"
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dde946d6593d53f10132dadd58ca7d38623e64be0c07bb5962951db23c09a7e3" => :big_sur
    sha256 "92d5f022ddfbc005173a7fb3faeb533e1e1d1d3c9f5869905e1407d67e20ae9f" => :catalina
    sha256 "915a7a93fa0b9e88491dacf6b47c9f4634d051b7af3bd14ec589585d3bed9608" => :mojave
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
