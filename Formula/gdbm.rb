class Gdbm < Formula
  desc "GNU database manager"
  homepage "https://www.gnu.org/software/gdbm/"
  url "https://ftp.gnu.org/gnu/gdbm/gdbm-1.20.tar.gz"
  mirror "https://ftpmirror.gnu.org/gdbm/gdbm-1.20.tar.gz"
  sha256 "3aeac05648b3482a10a2da986b9f3a380a29ad650be80b9817a435fb8114a292"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "2eea26ad3d3d013c3ed2e2b985d4749719e8be327bc53b615a1ffbe484264599"
    sha256 cellar: :any, big_sur:       "3581501b051db1c0d1acccc710fe04453b61777e4d67110485ceca69f30d6d1a"
    sha256 cellar: :any, catalina:      "a3e43170a1d8413e6817e57b7218828af22a20b2221d804ad529a68248840a51"
    sha256 cellar: :any, mojave:        "996020d1bc3e8a8060a9fe49b992cd66e7404346a339ae98ef92090724f36fda"
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
