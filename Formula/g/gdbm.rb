class Gdbm < Formula
  desc "GNU database manager"
  homepage "https://www.gnu.org.ua/software/gdbm/"
  url "https://ftp.gnu.org/gnu/gdbm/gdbm-1.25.tar.gz"
  mirror "https://ftpmirror.gnu.org/gdbm/gdbm-1.25.tar.gz"
  sha256 "d02db3c5926ed877f8817b81cd1f92f53ef74ca8c6db543fbba0271b34f393ec"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_sequoia: "5050faa58577426f4bb8b0fb940f8c8d62d0f25484d563bc0bb0e01d96cfa1a0"
    sha256 cellar: :any, arm64_sonoma:  "65868b2118aa71aa381c8739a9ad5dd985e2c4abff095228bb43b40884b62129"
    sha256 cellar: :any, arm64_ventura: "ca9a4a46ef61e5507489136ddea13be718d95ed7a25797c88b8e6d53022683a2"
    sha256 cellar: :any, sonoma:        "00c0754eaf6d73774c0bd48a173c83fb9fdf27f737b9730928442eb77c29fa0c"
    sha256 cellar: :any, ventura:       "10080cd256c860ccef00b7abac526615cc45b1baa24df81ea4733de939db7fd1"
    sha256               arm64_linux:   "347fe6091f508ee3e0b92a54e3e8c1b2f05e40db5c66a183b130de9306e3e33f"
    sha256               x86_64_linux:  "f95b2737b4b0513b3b04e850c44d3f365f2872baa6325e9c3bc8adc3497fc236"
  end

  # Backport fix for macOS
  patch do
    url "https://git.savannah.gnu.org/cgit/gdbm.git/rawdiff/?id=ed0a865345681982ea02c6159c0f3d7702c928a1"
    sha256 "cdba23a8da0bbdf91921247d226f9ca13e2a1c9541434f7a9132ba39346762ad"
  end

  def install
    # --enable-libgdbm-compat for dbm.h / gdbm-ndbm.h compatibility:
    #   https://www.gnu.org.ua/software/gdbm/manual/html_chapter/gdbm_19.html
    # Use --without-readline because readline detection is broken in 1.13
    # https://github.com/Homebrew/homebrew-core/pull/10903
    args = %w[
      --disable-silent-rules
      --enable-libgdbm-compat
      --without-readline
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"

    # Avoid conflicting with macOS SDK's ndbm.h.  Renaming to gdbm-ndbm.h
    # matches Debian's convention for gdbm's ndbm.h (libgdbm-compat-dev).
    mv include/"ndbm.h", include/"gdbm-ndbm.h"
  end

  test do
    pipe_output("#{bin}/gdbmtool --norc --newdb test", "store 1 2\nquit\n")
    assert_path_exists testpath/"test"
    assert_match "2", pipe_output("#{bin}/gdbmtool --norc test", "fetch 1\nquit\n")
  end
end
