class Gnuplot < Formula
  desc "Command-driven, interactive function plotting"
  homepage "http://www.gnuplot.info/"
  url "https://downloads.sourceforge.net/project/gnuplot/gnuplot/5.4.6/gnuplot-5.4.6.tar.gz"
  sha256 "02fc27918200ed64d8f0c3b84fe81b95b59cd47ad99f270939ae497c19f27419"
  license "gnuplot"

  bottle do
    sha256 arm64_ventura:  "e1ee33c426c0e999d2130719993b1325b8581a6e24dc0b7607a1126ca37d85a4"
    sha256 arm64_monterey: "a5377332f5d9267465592e995b75caa03072ac5bc7c97199f8c7a5223c16f424"
    sha256 arm64_big_sur:  "bc29f9bdc331596efbe2d0dbaec5d58ba906f43e36da196f39bc6171ef78b28e"
    sha256 ventura:        "592d1e63ed1991415bd7910cd88329f691b32094d5a2758584e8f009f17f436c"
    sha256 monterey:       "2929fe528e2e302fab4311dad74fdf2a76d13ae7cac80373fd27adf1a0ea5ea2"
    sha256 big_sur:        "8f73b87113230e18359d82e1b0baf46b4b6515db5538fdb0d1bad274e55c0699"
    sha256 x86_64_linux:   "0769eaadb11f6912558530b4527c6eeb95a85adc2ef35de70a9a3f5d6f94d30d"
  end

  head do
    url "https://git.code.sf.net/p/gnuplot/gnuplot-main.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gd"
  depends_on "libcerf"
  depends_on "lua"
  depends_on "pango"
  depends_on "qt@5"
  depends_on "readline"

  fails_with gcc: "5"

  def install
    # Qt5 requires c++11 (and the other backends do not care)
    ENV.cxx11

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-readline=#{Formula["readline"].opt_prefix}
      --without-tutorial
      --disable-wxwidgets
      --with-qt
      --without-x
      --without-latex
    ]

    system "./prepare" if build.head?
    system "./configure", *args
    ENV.deparallelize # or else emacs tries to edit the same file with two threads
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/gnuplot", "-e", <<~EOS
      set terminal dumb;
      set output "#{testpath}/graph.txt";
      plot sin(x);
    EOS
    assert_predicate testpath/"graph.txt", :exist?
  end
end
