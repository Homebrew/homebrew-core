class Gdbm < Formula
  desc "GNU database manager"
  homepage "https://www.gnu.org/software/gdbm/"
  url "https://ftp.gnu.org/gnu/gdbm/gdbm-1.21.tar.gz"
  mirror "https://ftpmirror.gnu.org/gdbm/gdbm-1.21.tar.gz"
  sha256 "b0b7dbdefd798de7ddccdd8edf6693a30494f7789777838042991ef107339cc2"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_big_sur: "fd3c1830264b732ad953e0ec41dd8325ac3c07fc8bf3b8a55a968f4f8947ecc5"
    sha256 cellar: :any, big_sur:       "a0390a4a2b661b19ca7ef9736aea3df13afda10d13600d7a7e25e0686f97a4d6"
    sha256 cellar: :any, catalina:      "5037ab5bfdebab730434d93c09ac44a19194edb49fabc25563736695aa2bc309"
    sha256 cellar: :any, mojave:        "fbe153ad0a746da6ee2dcadb81f6db06bd226945cfa71c61f9215944fa60971b"
    sha256               x86_64_linux:  "9be34c0de7f42af7b6837a3d0e13bb6e0857bdee1e1e6020b805365c8b41070f"
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
