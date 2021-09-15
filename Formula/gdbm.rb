class Gdbm < Formula
  desc "GNU database manager"
  homepage "https://www.gnu.org/software/gdbm/"
  url "https://ftp.gnu.org/gnu/gdbm/gdbm-1.20.tar.gz"
  mirror "https://ftpmirror.gnu.org/gdbm/gdbm-1.20.tar.gz"
  sha256 "3aeac05648b3482a10a2da986b9f3a380a29ad650be80b9817a435fb8114a292"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "5c3247c107bc2975dec7baecff33bde0b40d50800da0d44eae17b07d4712a27c"
    sha256 cellar: :any, big_sur:       "ea88ce09e934407b1c7dfcc1b74e2d4f1b409f8264b4475b816369a129c6cd25"
    sha256 cellar: :any, catalina:      "2c62d9ef89fc346310fe219ce55c37f8673cd95672f21c5c7af6d991a52dc7fb"
    sha256 cellar: :any, mojave:        "e31aaf7e8d02d811883dba4fd804954f226d8f112974293c6d6b7a8b66648554"
    sha256               x86_64_linux:  "0cef41f29293302f68aac94fab6d6363217de9c867aad59d41c42e3cab73589a"
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
