class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.0.1.tar.gz"
  sha256 "886ba97f8d71a3fb83aba57f53022b5daf10576dc50f9d8e8d81f4db3090350e"
  license "MIT"
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "676738d8dfae0c432556082a7048bb0d7d1fd191a8dbf517916e62169a3ea62c" => :catalina
    sha256 "589481d1c206d3802898f6d0be803935f22f2ddf29388044ede1d6f5ef30c847" => :mojave
    sha256 "ee87de222dd6112c2f0638a766b12c50152c5ae50202941c76f846f69f4b69a1" => :high_sierra
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
