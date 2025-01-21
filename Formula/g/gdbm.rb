class Gdbm < Formula
  desc "GNU database manager"
  homepage "https://www.gnu.org.ua/software/gdbm/"
  url "https://ftp.gnu.org/gnu/gdbm/gdbm-1.24.tar.gz"
  mirror "https://ftpmirror.gnu.org/gdbm/gdbm-1.24.tar.gz"
  sha256 "695e9827fdf763513f133910bc7e6cfdb9187943a4fec943e57449723d2b8dbf"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "49b4c0481d8bc5fdab3162d6b2af006ad5de3e5ba163825a201f23ef9db32ac4"
    sha256 cellar: :any, arm64_sonoma:   "439b678f3befe6e37a2e36c9a8df727137f5a86bdf0fdf6a2e612409ffe1409a"
    sha256 cellar: :any, arm64_ventura:  "9517b85db682569c03ebd86330b2e4d7f5a044d48352e971ce36bee738cddc2c"
    sha256 cellar: :any, arm64_monterey: "fc44f8e15beecf80991b2856a0e85309c68e0562d4ca7fe656fcb94c122fcf40"
    sha256 cellar: :any, sonoma:         "20b4d20aab87fe96f59914aa5d012066342519b86bd6961696feade676b80fa9"
    sha256 cellar: :any, ventura:        "de0719d7d530b03c71fb7f4d29244d9eac7691b614f570475a4ef22bf568fd20"
    sha256 cellar: :any, monterey:       "3aa7e2f745e8ca1f6f8425c48a290855c34cac823c7d42a8e7d0ff0933e5e0d8"
    sha256               x86_64_linux:   "7fd35749fc28a0bf5e2f3c7cc74d8e2da38914d3009127cbedf9cf617cb6fe61"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
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
