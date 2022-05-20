class Gnuplot < Formula
  desc "Command-driven, interactive function plotting"
  homepage "http://www.gnuplot.info/"
  url "https://downloads.sourceforge.net/project/gnuplot/gnuplot/5.4.3/gnuplot-5.4.3.tar.gz"
  sha256 "51f89bbab90f96d3543f95235368d188eb1e26eda296912256abcd3535bd4d84"
  license "gnuplot"
  revision 1

  bottle do
    sha256 arm64_monterey: "8434d860865ab948c40b82e8ed9cfc20697e153f1018c747df82f21ec71ffc70"
    sha256 arm64_big_sur:  "c528b21b25c7c35f67cae3e71ea9f555112cd61f0add956d76e57a6f4cc6870b"
    sha256 monterey:       "5d66c5093a628fc3169e1d844a818710e63fe959258a51d25aee2ebad7b2724a"
    sha256 big_sur:        "355caca1944918dc774073f8cbbe96355f04b2731cb73d2d0f0664a646404183"
    sha256 catalina:       "b0dc5bf8e5b3c703e0a3b590d130a9105849639f622189d9f49a7b4ad33619c9"
    sha256 x86_64_linux:   "5171dbbb1add97ec81e2540392b89d9c271af07c1f6f5922376e6110319ef792"
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
