class Calc < Formula
  desc "Arbitrary precision calculator"
  homepage "http://www.isthe.com/chongo/tech/comp/calc/"
  url "http://www.isthe.com/chongo/src/calc/calc-2.12.6.5.tar.bz2"
  sha256 "4e79a4e4615b92c1d8533e9ab4fdaca95715aaed45405c29daa886f8a1236733"

  bottle do
    sha256 "0adef80aadb860be5fd0e01d6b843364df9f4fb38665715bf2428773c28f8385" => :high_sierra
    sha256 "c5af5a309327a041326026af0b2c56bee4f823bb016fb592d9d47ce3593bdf38" => :sierra
    sha256 "0fdea569d70f771ed02cae8ac4b175cb5810db6acfabb14b1f0e3031bf375822" => :el_capitan
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
