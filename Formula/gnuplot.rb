class Gnuplot < Formula
  desc "Command-driven, interactive function plotting"
  homepage "http://www.gnuplot.info/"
  url "https://downloads.sourceforge.net/project/gnuplot/gnuplot/5.2.7/gnuplot-5.2.7.tar.gz"
  sha256 "97fe503ff3b2e356fe2ae32203fc7fd2cf9cef1f46b60fe46dc501a228b9f4ed"
  revision 1

  bottle do
    sha256 "c5f7eb8ca16ddc90c9c14f100c43c46c5be179dc1389bf85e1d7726dd862c6d7" => :mojave
    sha256 "4f09ccc4c4bf56c65873e20f7265df44fcbec3e319592a2d6870ee3a06a60dfa" => :high_sierra
    sha256 "33c03c8bff2e427d6c2b25575de43b8c41041919b79c320b1a57a8de23cb5d7d" => :sierra
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
