class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://www.graphviz.org/"
  url "https://gitlab.com/graphviz/graphviz.git",
      tag:      "6.0.1",
      revision: "c793ee4d72674afa0e6969ab77bcf83581beccb5"
  license "EPL-1.0"
  version_scheme 1
  head "https://gitlab.com/graphviz/graphviz.git", branch: "main"

  bottle do
    sha256 arm64_monterey: "6b4c4fbc2d1679960de86016eed58850f0a30d963e47430927066a7716852bdd"
    sha256 arm64_big_sur:  "ad99581abefc4ebd00d4ab375980bae4d1eaef56260cc0e236e98b48eaf0b599"
    sha256 monterey:       "f424beb0d430dbf2530cc5aa559f9302bbeaff1f55698faef0dd2158c88dbf95"
    sha256 big_sur:        "e9f8e8e2416a94714a8e1cb0083f5fd75dfaca1e727ecaef1726f42652e48c7b"
    sha256 catalina:       "2a780aa518ab424d6bab970c407e9fc189cc48c710e90b36f2b296c4e72cdf85"
    sha256 x86_64_linux:   "a0afb14477971b60986160ec91a01764bf5115508b49d4a94e7520b1448472b9"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "gd"
  depends_on "gts"
  depends_on "libpng"
  depends_on "librsvg"
  depends_on "libtool"
  depends_on "pango"

  uses_from_macos "flex" => :build
  uses_from_macos "python" => :build

  on_linux do
    depends_on "byacc" => :build
    depends_on "ghostscript" => :build
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-php
      --disable-swig
      --disable-tcl
      --with-quartz
      --without-freetype2
      --without-gdk
      --without-gdk-pixbuf
      --without-gtk
      --without-poppler
      --without-qt
      --without-x
      --with-gts
    ]

    system "./autogen.sh"
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"sample.dot").write <<~EOS
      digraph G {
        a -> b
      }
    EOS

    system "#{bin}/dot", "-Tpdf", "-o", "sample.pdf", "sample.dot"
  end
end
