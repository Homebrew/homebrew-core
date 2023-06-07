class Gnuplot < Formula
  desc "Command-driven, interactive function plotting"
  homepage "http://www.gnuplot.info/"
  url "https://downloads.sourceforge.net/project/gnuplot/gnuplot/5.4.8/gnuplot-5.4.8.tar.gz"
  sha256 "931279c7caad1aff7d46cb4766f1ff41c26d9be9daf0bcf0c79deeee3d91f5cf"
  license "gnuplot"

  bottle do
    sha256 arm64_ventura:  "d28fd17192c568cab10c13b72944bc9076121faceb2dab7e2c51cce1e6fb0c22"
    sha256 arm64_monterey: "f87bb3fa742ae6eb041f23825053f28d2dc9e5975b59b3664a446b84e40e038c"
    sha256 arm64_big_sur:  "813bba15d876c4135ae2c0d9ca9f53c0365f251ec330dbf6d9ec55ef4793a046"
    sha256 ventura:        "bebc366a17cfb9642ffe889d34c6dd76763d75ef255c00bf607c9529d8e9420c"
    sha256 monterey:       "eb54ce5936943b9c1d30c67dfb979c416fb35511741052a840985f2ef3110cea"
    sha256 big_sur:        "65d82798f52b983f01921fbcf7b1b2c76e88aefd9ab684c8a2e9c4ed591fc998"
    sha256 x86_64_linux:   "5b92e8302552d465b54c149bd6b54645db88b8a1b4aeeaab5c85a6f2751a36ac"
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
