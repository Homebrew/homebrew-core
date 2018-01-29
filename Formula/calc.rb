class Calc < Formula
  desc "Arbitrary precision calculator"
  homepage "http://www.isthe.com/chongo/tech/comp/calc/"
  url "http://www.isthe.com/chongo/src/calc/calc-2.12.6.5.tar.bz2"
  sha256 "4e79a4e4615b92c1d8533e9ab4fdaca95715aaed45405c29daa886f8a1236733"

  bottle do
    sha256 "4c23c15fd4769f366959ea45334708619dcb328bedaf407deb91f3c7ff531071" => :high_sierra
    sha256 "696195ac28f95b82407edd1c7b9e940d7c79f9e381d3edfd1cb55836e683d46d" => :sierra
    sha256 "4226244dfd6c1d3b76118410abff8a3b1d6a690ac6d4d9f557f2a2a426679901" => :el_capitan
    sha256 "2c13a2783df064a03d53271847a3ce52e89668be25ec5ea6c287179d2cfa760e" => :yosemite
  end

  depends_on "readline"

  def install
    ENV.deparallelize

    ENV["EXTRA_CFLAGS"] = ENV.cflags
    ENV["EXTRA_LDFLAGS"] = ENV.ldflags

    readline = Formula["readline"]

    system "make", "install", "INCDIR=#{MacOS.sdk_path}/usr/include",
                              "BINDIR=#{bin}",
                              "LIBDIR=#{lib}",
                              "MANDIR=#{man1}",
                              "CALC_INCDIR=#{include}/calc",
                              "CALC_SHAREDIR=#{pkgshare}",
                              "USE_READLINE=-DUSE_READLINE",
                              "READLINE_LIB=-L#{readline.opt_lib} -lreadline",
                              "READLINE_EXTRAS=-lhistory -lncurses"
    libexec.install "#{bin}/cscript"
  end

  test do
    assert_equal "11", shell_output("#{bin}/calc 0xA + 1").strip
  end
end
