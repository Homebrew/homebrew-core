class Nnn < Formula
  desc "Free, fast, friendly file browser"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/v1.9.tar.gz"
  sha256 "7ba298a55a579640fe0ae37f553be739957da0c826f532beac46acfb56e2d726"
  head "https://github.com/jarun/nnn.git"

  bottle do
    cellar :any
    sha256 "7d8829e7ec6eacc571c3ca7b0acfb2b67b1313ea1e1419f9ce700267290cf08e" => :mojave
    sha256 "1a5307183b08ea9a51b604c099748063a28c038e2eb4967a8294f031a4fe5721" => :high_sierra
    sha256 "549480ce88b7051f40251198c671333b33f0ee0ca43fa93d686bef8501673f8b" => :sierra
    sha256 "269fc2640b01a4f21f6f4387cffe9a52b7483f1ffcc94e54070185cf27038ade" => :el_capitan
  end

  depends_on "readline"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Testing this curses app requires a pty
    require "pty"

    PTY.spawn(bin/"nnn") do |r, w, _pid|
      w.write "q"
      assert_match testpath.realpath.to_s, r.read
    end
  end
end
