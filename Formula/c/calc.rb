class Calc < Formula
  desc "Arbitrary precision calculator"
  homepage "http://www.isthe.com/chongo/tech/comp/calc/"
  url "https://downloads.sourceforge.net/project/calc/calc/2.15.0.4/calc-2.15.0.4.tar.bz2"
  sha256 "35ce2940ddf4f5f14b8b1f08eb053d4abcade2d3b3d5842f2f5b468e1ea3d1e9"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sonoma:   "7c3a8c90d10e337f3f5fd77863b994139e79f27263a6e9dab831ea2d695e5e4e"
    sha256 arm64_ventura:  "b33dceb9c9103598a29b48cb0f7f63e476c6305f3fdeb9058a596c2cb34c78b1"
    sha256 arm64_monterey: "8703947c61d75f663edb9eb3878b419acf7883dd8b9e7a24c926d1a709cd731b"
    sha256 sonoma:         "e7e6f59e0eb242bf5541c2b6be8c66011524c03f7a6126318f2d22a96a8f9c5f"
    sha256 ventura:        "10dfb232fca04543b32eedba6c96b5fcf24cd84f4d960212a38b35c068622bdf"
    sha256 monterey:       "7eae117605ecdecb92277e0df5e97f1a5babd4aa505afe11e3d2bd2b2ff6d6e0"
    sha256 x86_64_linux:   "fd05947f905a94ac32bbe0029948562b6579fd231f18804a4b771df20d39ff8c"
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
