class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.0.0.tar.gz"
  sha256 "f4c9e60f1589b7f4aba1e89d414ddde9dabf1c38e8dfd693b405827cfcb8e175"
  license "MIT"
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "422f94ca0003fe6c2aa822159f7aeb6c6cd69b0a0d257c25da57227ccf6210f1" => :catalina
    sha256 "c2ca888fb22f6c9c91f9842537db270822bc85d251d3b2f1df2e41fda5ba49f1" => :mojave
    sha256 "012b1efd10bdd1cb3947506be3c9133d68e61fa8c4e1d351f574efdad5f9bb76" => :high_sierra
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
