class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://graphviz.org/"
  url "https://gitlab.com/graphviz/graphviz.git",
      tag:      "7.0.6",
      revision: "8e32e661fcc55985d8cc593b02b524709df19c37"
  license "EPL-1.0"
  version_scheme 1
  head "https://gitlab.com/graphviz/graphviz.git", branch: "main"

  bottle do
    sha256 arm64_ventura:  "f3bc5ab00ad56e4794ce0432bd6403c126d5bc91be7783b5d976c2319de14561"
    sha256 arm64_monterey: "116d6deeaa3e0b3a08c270c753eb06c7191ec0abebc870838d5b63bb798b93e8"
    sha256 arm64_big_sur:  "13a3e42b7c55f0a9393ca3f9e42b6331ff33bdb9ab6916cecab4f7019ae13271"
    sha256 ventura:        "09739733397810c9b5017edc81ab3a47665b0188fdafce939352bca306c40c70"
    sha256 monterey:       "3b182d1ea479d75ac01561ff1d4a9c4e6adbfabe54a6ce65337ba88a259d8cb4"
    sha256 big_sur:        "3fd80a458ea9eb6e4ee89ea508b7b5f09d6da1515c9ac7d351420509662eaef4"
    sha256 x86_64_linux:   "14153cdbabf1e30daadc88b6580d97d8c636c49f133d2625bf0cc8e2a99d488f"
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
