class Calc < Formula
  desc "Arbitrary precision calculator"
  homepage "http://www.isthe.com/chongo/tech/comp/calc/"
  url "http://www.isthe.com/chongo/src/calc/calc-2.12.5.6.tar.bz2"
  sha256 "76090203a96d35dd10103112a7ad612f4d9b0526b758f2f49ac5bef02ba7cb39"

  bottle do
    sha256 "dd0ed50f3e98e105a46b378352bfecda1562c9bb79524d77a63fc7ec46e8ed64" => :sierra
    sha256 "4e7746c70e2bc113ff9bdc0308ebf5b79a58aca2dc0b208d0cb1dce698714abd" => :el_capitan
    sha256 "23fd7dc2862b7f8f139d2b2e7263f478d9b1b45c5be7c8f6665cd8adfca78f28" => :yosemite
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
