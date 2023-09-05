class Calc < Formula
  desc "Arbitrary precision calculator"
  homepage "http://www.isthe.com/chongo/tech/comp/calc/"
  url "https://downloads.sourceforge.net/project/calc/calc/2.14.3.5/calc-2.14.3.5.tar.bz2"
  sha256 "e1e5ece8d0dfb093b956bf4ca368c2d7a853440cadfbed6cf99fc9ad60cac149"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_ventura:  "198f859ac5b8e6c57fc8b2cf4dc66aa71c786f979006bb0730d747d33f3da39b"
    sha256 arm64_monterey: "6d1537f3838c79281e8a4049a401e94ddc789a4ff1dffdf25b88c8632ddcf74e"
    sha256 arm64_big_sur:  "24cb65639e84d9cb00f828203ef564a11548da2c8cba386b67539ab0d0c1969a"
    sha256 ventura:        "ada2a34eded414053936b2b8e5afe242ac3315d05be705349c3e90580dcc22c9"
    sha256 monterey:       "d9cca1818f7f3e36129503b784f47463f1401cac84316b1cd5e2da73e3a015c4"
    sha256 big_sur:        "c72570cd8b950e8101bc26b3a2a9886587f1861492d20eb40e316296925570d4"
    sha256 x86_64_linux:   "56045b00bb5dbf76bf5c0fee565d35ede49432410fff04698f9794ebaeaccf76"
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
