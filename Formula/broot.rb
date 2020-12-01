class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.0.8.tar.gz"
  sha256 "216f39359f14eb32f8c7d3eb708ef095c6918f76bee9d2cbfb1571449025b68c"
  license "MIT"
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "05cd630ea76ef88bb53a22bb64130576a04b3362be405e628b8f431a2dc0cdcb" => :big_sur
    sha256 "c07b23654b8b430a548b0e825f9e7ff8eeab71fdf224a4dcaf4815dc6799fd9e" => :catalina
    sha256 "93265532ffc56e021332752a5b7b9fec2998088fafaba6ef763da1548c634b6f" => :mojave
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
