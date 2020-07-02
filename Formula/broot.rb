class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot"
  url "https://github.com/Canop/broot/archive/v0.18.4.tar.gz"
  sha256 "a4369cf1b375009d641ab7f52ff85303fa30aea2ea7c2807acc4b0f561f0bc4e"
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "77631c9cd67cb3d3b46ec795f26a70b6c81375ba3659e85f90f67588a3e570e4" => :catalina
    sha256 "3b679acce747c0dde24f1496ae8c303eccea3f06f3da7de9beb7c8a28a8eb014" => :mojave
    sha256 "d1646aa8177e130c8c0cbb1d651b9e6288f1fa1b7ac0c634a3871e038c4e89c4" => :high_sierra
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
