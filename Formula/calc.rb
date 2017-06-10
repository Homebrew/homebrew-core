class Calc < Formula
  desc "Arbitrary precision calculator"
  homepage "http://www.isthe.com/chongo/tech/comp/calc/"
  url "http://www.isthe.com/chongo/src/calc/calc-2.12.6.0.tar.bz2"
  sha256 "18dee9d979d8d397ee4a6f57c494a60790034c0ff109b3c552faff97f1ad7cf2"

  bottle do
    sha256 "16ccd7da1589460bde50fe479b52d915f63070bac3a17d0e0d7f95fff0eac21c" => :sierra
    sha256 "43b7e9c234b31bf385eb14b8cc2c5f0bbff88d617161e943d44cbcdf1c0231b9" => :el_capitan
    sha256 "5f8490d3d5205d328b8b2be27e3a5a8267f1dadd047468812807add4e699084f" => :yosemite
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
