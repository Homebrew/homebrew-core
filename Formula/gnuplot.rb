class Gnuplot < Formula
  desc "Command-driven, interactive function plotting"
  homepage "http://www.gnuplot.info/"
  url "https://downloads.sourceforge.net/project/gnuplot/gnuplot/5.4.2/gnuplot-5.4.2.tar.gz"
  sha256 "e57c75e1318133951d32a83bcdc4aff17fed28722c4e71f2305cfc2ae1cae7ba"
  license "gnuplot"

  bottle do
    sha256 arm64_monterey: "d0472338d81e365141cc79b78cbfcf955240b77ef521bcbf5682a1b3c426d9fa"
    sha256 arm64_big_sur:  "27a1fe2a1a18339f161cf3e8e5798864265bea2e7c826d2c4f73f644656b0098"
    sha256 big_sur:        "c2ee49f0e0df611f3955e6380a30020d2d4a2b7cfff4a769d32f20b9bf46b250"
    sha256 catalina:       "8419141f6d01b54a0df20e6f1606f8555fbb915bf236a0a225711eaea4886ac5"
    sha256 mojave:         "a617cb5b3bcc7f961f1b107ee56d5da12108b51797f92b11081b2c1ff54c279e"
    sha256 x86_64_linux:   "6fda7e17bb4f7ebab74bc77b43d8b63cf4386d319b0c29f476f61717da46851a"
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

  on_linux do
    depends_on "gcc"
  end

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
