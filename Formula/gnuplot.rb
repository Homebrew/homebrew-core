class Gnuplot < Formula
  desc "Command-driven, interactive function plotting"
  homepage "http://www.gnuplot.info/"
  url "https://downloads.sourceforge.net/project/gnuplot/gnuplot/5.4.4/gnuplot-5.4.4.tar.gz"
  sha256 "372300b7867f5b3538b25fc5d0ac7734af6e3fe0d202b6db926e4369913f0902"
  license "gnuplot"

  bottle do
    sha256 arm64_monterey: "397145507ccbb8b18d3b905b7aadbe6ff245c52eafcbcebf03ee1c3b4d9d53cf"
    sha256 arm64_big_sur:  "d425c0cf13e4ccbf26bd026e5676027ecb039c556d38f8d0586856f47c9a9c4e"
    sha256 monterey:       "f7d2153dcfa662bbf84ce32a40474e77330e07424ec7b020c0cd178f35cd0a30"
    sha256 big_sur:        "924b2e49026dc90a5cc8097b36776797765578baa09e0681231caf2bfb3a80e5"
    sha256 catalina:       "bb28e77545fc22d9dfd1b2bab184be15916a722b0e0024a20764d3e550520f45"
    sha256 x86_64_linux:   "3adcbd0950fe8c1ad0d65d9ec46144d93c3421d0127bc5d1c228653ca3d3c1b2"
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
