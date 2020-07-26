class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v0.19.2.tar.gz"
  sha256 "7d26392e1e70d382d20ef478a2dfa093c410f8db2d2689615c89cf3f69166063"
  license "MIT"
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "35cacc4caebb27f9da5f647d7fe373ae8813314d1deb080a5aee18bad5741999" => :catalina
    sha256 "df06367fd7c2c650e5dccf1c67df86f46ffbe1eb6cc228ee3ed6edeebdcb1271" => :mojave
    sha256 "ea668e1b6e562711f42bbec31102ffdaae74c465d75cddf6e8fbc4aa03684b4e" => :high_sierra
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
