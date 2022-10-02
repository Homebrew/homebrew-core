class Gnuplot < Formula
  desc "Command-driven, interactive function plotting"
  homepage "http://www.gnuplot.info/"
  url "https://downloads.sourceforge.net/project/gnuplot/gnuplot/5.4.5/gnuplot-5.4.5.tar.gz"
  sha256 "66f679115dd30559e110498fc94d926949d4d370b4999a042e724b8e910ee478"
  license "gnuplot"

  bottle do
    rebuild 1
    sha256 arm64_monterey: "747cde79b524c5f8aa457ff5d64bb7d67cb18c09d8d1131394dd6a27ce873772"
    sha256 arm64_big_sur:  "14bce54eeb825dde24a8e16d3fe0418211b94827752faf0ae606ff6f3b0c7a35"
    sha256 monterey:       "b1f287106aa78ce2fdb88152d103fd5509cd2343b223a53e3648c545dd611613"
    sha256 big_sur:        "a4b81c9d0eff4a3d60b57e7f20d8f6c15d90542f9255842101984a2beb00b148"
    sha256 catalina:       "b3e8dc8322ede575e7f287ab2308845e7146469da761f9bea0a2a5944619822c"
    sha256 x86_64_linux:   "5663a25c03185c8d08f30ec8e323e2333f8d70051eaeeb5e24a0a9cc1215b94a"
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
