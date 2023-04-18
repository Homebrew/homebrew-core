class Gnuplot < Formula
  desc "Command-driven, interactive function plotting"
  homepage "http://www.gnuplot.info/"
  url "https://downloads.sourceforge.net/project/gnuplot/gnuplot/5.4.6/gnuplot-5.4.6.tar.gz"
  sha256 "02fc27918200ed64d8f0c3b84fe81b95b59cd47ad99f270939ae497c19f27419"
  license "gnuplot"

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "9ef39f0cb000b8dd008db72f49cd277041b8ba3f34f15b3995d972e6612a50c5"
    sha256 arm64_monterey: "d1b94c5596e51a56aa333c5ec14cc38c44255fd6825ec76a01b14c97bc09473b"
    sha256 arm64_big_sur:  "2398694f2376c3f317f7149ca6f2982ecf601c49089f2daeb1ef23321082af2e"
    sha256 ventura:        "8124f27d5b1f367e4b1db8461e0bbb57c55827dae0f3827e911ad4b8683b5756"
    sha256 monterey:       "51b119f2ad7b52edb828b0ed20604eaf863c3d7de9b785bbec60277ab6404597"
    sha256 big_sur:        "1a89eec4082121ca67df4fd46f2557a46d69f0d93a6a47a95bdb1867fdaebbdc"
    sha256 x86_64_linux:   "308b8f7cef916cb9b220ad681a52e6df118c0582e3d4d793718600220db12ddd"
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
