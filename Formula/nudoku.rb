class Nudoku < Formula
  desc "ncurses based sudoku game"
  homepage "https://jubalh.github.io/nudoku/"
  url "https://github.com/jubalh/nudoku/archive/0.2.5.tar.gz"
  sha256 "1478c339409abe8f1b857bf3e54c5edbeb43954432fb6e427e52a3ff6251cc25"
  head "https://github.com/jubalh/nudoku.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ac37d01053c8eae43bd32d9ec94f6800597f369861dcde7b58830d177b00c65a" => :sierra
    sha256 "d4d1ff67b4e28496e3ce0458ed90802ac8833ebf1739e86265f05c9c4309ada5" => :el_capitan
    sha256 "7f1a30844a239c14e7c87b49b3ec4351320e7713682e1c12cb0804ec4a6dc5c7" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "nudoku version #{version}", shell_output("#{bin}/nudoku -v")
  end
end
