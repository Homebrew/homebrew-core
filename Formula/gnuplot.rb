class Gnuplot < Formula
  desc "Command-driven, interactive function plotting"
  homepage "http://www.gnuplot.info/"
  url "https://downloads.sourceforge.net/project/gnuplot/gnuplot/5.4.7/gnuplot-5.4.7.tar.gz"
  sha256 "318a1501c9e659f39cf05ee5268335671bddc6c20eae06851f262fde27c2e739"
  license "gnuplot"

  bottle do
    sha256 arm64_ventura:  "8e495bfb0d8d9453e657da5c4626e2241d8966a367b9ea12f3f22b4ec38c4a6b"
    sha256 arm64_monterey: "0127d9b87f57536e1c1dbfa09ed70f0208853983957753856f6f25419a026d70"
    sha256 arm64_big_sur:  "aef018b30276812289646cffa27862bc1173ad8295aa0348cec5c091b7311834"
    sha256 ventura:        "c6dcb68a2b5bfc7013def776a89fc8f332b65473fa64ebbaa7340f006ca46ed6"
    sha256 monterey:       "1a7b319441d548717db55c3bd3dd31e84388ef750499471e35ed0bbc1e25eefe"
    sha256 big_sur:        "eb1a2f23117ad4be9c9048f27958dd8d088518ab9078938b88af778db65e2c6a"
    sha256 x86_64_linux:   "a2878582dac68e82d1dc8afd870c92ad03186c6e25f9eb7a8e8716d5b82cae88"
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
