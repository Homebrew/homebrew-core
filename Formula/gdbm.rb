class Gdbm < Formula
  desc "GNU database manager"
  homepage "https://www.gnu.org/software/gdbm/"
  url "https://ftp.gnu.org/gnu/gdbm/gdbm-1.21.tar.gz"
  mirror "https://ftpmirror.gnu.org/gdbm/gdbm-1.21.tar.gz"
  sha256 "b0b7dbdefd798de7ddccdd8edf6693a30494f7789777838042991ef107339cc2"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_big_sur: "15e097602373e698a4c89507a781215eac68f83ff28cf8d2a25d637340e1d179"
    sha256 cellar: :any, big_sur:       "7abb94a713a1e25f5fc4c5218067abf6ad09bbd68967c21f01d5d69f88308dd4"
    sha256 cellar: :any, catalina:      "4bdb9659a78c19dc10778ecbf078c2c96ae68ab75c75145260b88e95fc80f86f"
    sha256 cellar: :any, mojave:        "a4e992de96a5f68d72c0d47da69cf70d5e3c315e15f8f77e0554a6758cadb805"
    sha256               x86_64_linux:  "3c1999d4430a0004c0a333993d32f1fdcc1695ecd23715d4986722d0b6703b13"
  end

  # Fix build failure on macOS. Merged upstream as
  # https://git.gnu.org.ua/gdbm.git/commit/?id=32517af75ac8c32b3ff4870e14ff28418696c554
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/ad16d309923dd7839d239e05c7fdd86d9b6e5207/gdbm/fix-st_mtim.diff"
    sha256 "09813e4a01a74fb1c510abbd98abd53c18f5dfb4e66475969f4b173b4ff96935"
  end

  # --enable-libgdbm-compat for dbm.h / gdbm-ndbm.h compatibility:
  #   https://www.gnu.org.ua/software/gdbm/manual/html_chapter/gdbm_19.html
  # Use --without-readline because readline detection is broken in 1.13
  # https://github.com/Homebrew/homebrew-core/pull/10903
  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-libgdbm-compat
      --without-readline
      --prefix=#{prefix}
    ]

    system "./configure", *args
    system "make", "install"

    # Avoid conflicting with macOS SDK's ndbm.h.  Renaming to gdbm-ndbm.h
    # matches Debian's convention for gdbm's ndbm.h (libgdbm-compat-dev).
    mv include/"ndbm.h", include/"gdbm-ndbm.h"
  end

  test do
    pipe_output("#{bin}/gdbmtool --norc --newdb test", "store 1 2\nquit\n")
    assert_predicate testpath/"test", :exist?
    assert_match "2", pipe_output("#{bin}/gdbmtool --norc test", "fetch 1\nquit\n")
  end
end
