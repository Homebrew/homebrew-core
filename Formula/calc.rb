class Calc < Formula
  desc "Arbitrary precision calculator"
  homepage "http://www.isthe.com/chongo/tech/comp/calc/"
  url "https://downloads.sourceforge.net/project/calc/calc/2.14.1.0/calc-2.14.1.0.tar.bz2"
  sha256 "0b5616652e31ee1b54585dcc8512d02180a12f8addc09c4049d3d08edb54af40"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_monterey: "3337186209883fd629feeebe71ebb0ff19d01d8a49ce5bddfd8f8ee2fff287dd"
    sha256 arm64_big_sur:  "bf3815ed47929fae13903c1a78256a62203bc2a98ba82bd434616864792cea15"
    sha256 monterey:       "5083e19e9d67c8e07fcab3f932a33c6f5897d8d2f5eaea785230ddaf07e46871"
    sha256 big_sur:        "072c7370adf74f4239009fc73a494e25eac8c37c73c2c3a466dee24e5e747655"
    sha256 catalina:       "9471c2dba3b6c708073487e20df03735821bd39862dcb503b5c869c2368e8691"
    sha256 x86_64_linux:   "ff579cea1d5e659a90e0c2fa7fed70e4d2b574b3b9f94a75c520453f654c9ca3"
  end

  depends_on "readline"

  on_linux do
    depends_on "util-linux" # for `col`
  end

  def install
    ENV.deparallelize

    ENV["EXTRA_CFLAGS"] = ENV.cflags
    ENV["EXTRA_LDFLAGS"] = ENV.ldflags

    args = [
      "BINDIR=#{bin}",
      "LIBDIR=#{lib}",
      "MANDIR=#{man1}",
      "CALC_INCDIR=#{include}/calc",
      "CALC_SHAREDIR=#{pkgshare}",
      "USE_READLINE=-DUSE_READLINE",
      "READLINE_LIB=-L#{Formula["readline"].opt_lib} -lreadline",
      "READLINE_EXTRAS=-lhistory -lncurses",
    ]
    args << "INCDIR=#{MacOS.sdk_path}/usr/include" if OS.mac?
    system "make", "install", *args

    libexec.install "#{bin}/cscript"
  end

  test do
    assert_equal "11", shell_output("#{bin}/calc 0xA + 1").strip
  end
end
