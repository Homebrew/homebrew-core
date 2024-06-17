class Calc < Formula
  desc "Arbitrary precision calculator"
  homepage "http://www.isthe.com/chongo/tech/comp/calc/"
  url "https://downloads.sourceforge.net/project/calc/calc/2.15.0.7/calc-2.15.0.7.tar.bz2"
  sha256 "4db9f7c5f7a205f0b106cdab2aabf932d03f0458c5e60a0801050d680b0e04d3"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sonoma:   "159a7fccdca0d3072bc96cca14468f05e6cf18881c696589ffea5640c2290646"
    sha256 arm64_ventura:  "08f60562513c9a99adad9180e423d6f3e398e569230a65fa5f0bb2ca89f968c2"
    sha256 arm64_monterey: "2940968bafc1c463e80b0b6402385a1090427f0caa38d142fe6edf194cdfb5f2"
    sha256 sonoma:         "c8bf76e5db73e5130a8473f1094abe7b5e71851ea78a3448259133c9fd8613bd"
    sha256 ventura:        "6b8659473701c46ba85d9448f90a38d90445ccec7c74b018dab22f1500c7b9a7"
    sha256 monterey:       "2d431bc42fd0bded5cd6beec9e2cb6bf06ce842bfa28f58f34793634ac9ccf41"
    sha256 x86_64_linux:   "b19ecd7863162d6ac06fef4eb21ebed0376bedb844319b23156127372373009e"
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
