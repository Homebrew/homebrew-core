class Gnuplot < Formula
  desc "Command-driven, interactive function plotting"
  homepage "http://www.gnuplot.info/"
  url "https://downloads.sourceforge.net/project/gnuplot/gnuplot/5.4.5/gnuplot-5.4.5.tar.gz"
  sha256 "66f679115dd30559e110498fc94d926949d4d370b4999a042e724b8e910ee478"
  license "gnuplot"

  bottle do
    sha256 arm64_ventura:  "c246651856ca531f7d8363b9ad595860c7c4d8147921b7b7c4331c52b6e603fb"
    sha256 arm64_monterey: "51ecb988ca7a8ce2ef5dbcb62216c3bcb3ad1e1d5a5f9e2ff96cc8fa0a4df545"
    sha256 arm64_big_sur:  "c3daac6fbc91bec92a684618c0d09748d4ce8839a11174022796834d9328b649"
    sha256 ventura:        "b2fc809c4c735e51ba9619c1db049f647d1d577e862e73710569a006660554e1"
    sha256 monterey:       "3da9430c2b26efc609638ccaa705894287f60525fdb5e801386a0eaf05718aaa"
    sha256 big_sur:        "f818709ded2f6eb3cb14beb9e20dbe31ff7be2d4e8655ee3dff9f81339499474"
    sha256 catalina:       "b348f93e05234b05ccd399be81bde105eee3a06c7a675de2092156982f7edf03"
    sha256 x86_64_linux:   "3ccc8649fe2dcde51f217fe74d4b033a2024d6dd23b904665214e86d89d4b7c7"
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
