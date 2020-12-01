class Gnuplot < Formula
  desc "Command-driven, interactive function plotting"
  homepage "http://www.gnuplot.info/"
  url "https://downloads.sourceforge.net/project/gnuplot/gnuplot/5.4.1/gnuplot-5.4.1.tar.gz"
  sha256 "6b690485567eaeb938c26936e5e0681cf70c856d273cc2c45fabf64d8bc6590e"
  license "gnuplot"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "26ea0150196aa8226b134676ff678d9f6fae15643c1d45ae525290bd59d058dc" => :big_sur
    sha256 "07e87a593917fbb66d6eef8efe30ee04531bde21c5d4a45775bae98b5314b42d" => :catalina
    sha256 "221b581e96e34f346ef8de648e8e4ddadf66250ec1b1d5d9a894d12846c11f0a" => :mojave
    sha256 "43bd44cae7f514c857f548f671c6b600b31e077c2aa783d1b63d5295c467a2ad" => :high_sierra
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
