class Gnuplot < Formula
  desc "Command-driven, interactive function plotting"
  homepage "http://www.gnuplot.info/"
  url "https://downloads.sourceforge.net/project/gnuplot/gnuplot/5.4.3/gnuplot-5.4.3.tar.gz"
  sha256 "51f89bbab90f96d3543f95235368d188eb1e26eda296912256abcd3535bd4d84"
  license "gnuplot"

  bottle do
    sha256 arm64_monterey: "eb85e735b54d3525eebc7e9023e35e0265633a189a0a7a28eb67d923c2672503"
    sha256 arm64_big_sur:  "4458590e1c71fee35fe0324b964a984fa2332a91b4bb0dc2af4c1ef4b55c3b63"
    sha256 monterey:       "4f84ad58c448e94fe7670189cdbf554eb1c88a8642dc312fe7dbd13c71097ada"
    sha256 big_sur:        "fdf18f8bd7001fe7f05e049e0b953b080c6fdcbf7e3e17a39b4645528bb397ca"
    sha256 catalina:       "b84af4fca336fe10b6447fe7307b56f526784aee1288c6de508019f4eb2bad83"
    sha256 x86_64_linux:   "04affc7a3e9b83f0c6a7a5e12bc39bf8d4493debadf635a394229f1ed412d475"
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
