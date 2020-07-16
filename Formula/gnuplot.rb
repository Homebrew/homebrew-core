class Gnuplot < Formula
  desc "Command-driven, interactive function plotting"
  homepage "http://www.gnuplot.info/"
  url "https://sourceforge.net/p/gnuplot/gnuplot-main/ci/5.4.0/tarball"
  sha256 "70e3ab9eaa5d32c2bb3274273ccfdda49b738d81fdc8e955a52e1ae8b9c1bf25"
  head "https://git.code.sf.net/p/gnuplot/gnuplot-main.git"

  bottle do
    sha256 "752b5a6f7e93af1e2a23e8ab27c6d19d286f50b054eb0b7accdfa5765c69b3b0" => :catalina
    sha256 "645bff55538d6610cf93539dbeec5067a750a6edc0fbbbab6e34710c16db10ef" => :mojave
    sha256 "36f2d97fbf5772eef3cd0f1988997848e7367ab7943a2542ea15d93bbfd083ce" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
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
