class Gnuplot < Formula
  desc "Command-driven, interactive function plotting"
  homepage "http://www.gnuplot.info/"
  url "https://downloads.sourceforge.net/project/gnuplot/gnuplot/5.4.1/gnuplot-5.4.1.tar.gz"
  sha256 "6b690485567eaeb938c26936e5e0681cf70c856d273cc2c45fabf64d8bc6590e"
  license "gnuplot"
  revision 2

  livecheck do
    url :stable
  end

  bottle do
    rebuild 1
    sha256 "9a9db26ab2b8537521d4ff508d4797c8535434ddd34748ab4044867d8eef65a0" => :big_sur
    sha256 "72a503fc93c60629c22d4f286d45365037d792d76c2f7ff8a76e6469641b0cc7" => :arm64_big_sur
    sha256 "1de9920502210ab56fbedc9bf4025ab8f0c88d164f022a1e767863f64b6e9954" => :catalina
    sha256 "19ed248f7d406ade2e6fd1faa28069878cd5b2a0b73911d735289478faaab8c3" => :mojave
  end

  head do
    url "https://git.code.sf.net/p/gnuplot/gnuplot-main.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gd"
  depends_on "libcerf"
  depends_on "lua"
  depends_on "pango"
  depends_on "qt"
  depends_on "readline"

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
