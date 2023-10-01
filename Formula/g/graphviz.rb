class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://graphviz.org/"
  url "https://gitlab.com/graphviz/graphviz.git",
      tag:      "9.0.0",
      revision: "5733d3a95898f1380424ab15f966ace9a283d506"
  license "EPL-1.0"
  version_scheme 1
  head "https://gitlab.com/graphviz/graphviz.git", branch: "main"

  bottle do
    sha256 arm64_sonoma:   "9c88e00ddc1c61fb3ac7af5057713d787592f2d67082414c77f3d74620af38e9"
    sha256 arm64_ventura:  "2cc4f492ac0cf9ba2365cc0e2e6763231b619868f7a4946ea3b4c5220c9af079"
    sha256 arm64_monterey: "3cba12a32c8f5cc97d487b9b77413218e777b55310452067c6ae7a2664c6df3c"
    sha256 arm64_big_sur:  "4dd9221c03b2039786e8a556389a4d9ccebcc6fc18fd17abff6795d0e8e6467b"
    sha256 sonoma:         "986a6deea25ccf3e888c2b66d4eca1cd5b6ae129c30422fa407cf42f91784dfe"
    sha256 ventura:        "064d78f90717572c3b20a6146b54562dffd50a6f5fb1aea08a3a59590aae9b09"
    sha256 monterey:       "c6abec7d7afa13f34292cf25a4277aa2559793d419b1c5ad24d23cde471ee795"
    sha256 big_sur:        "38f0fb9200716b0c703d0e383a964d3901aabe675e8c1accfbeb15f255083b3e"
    sha256 x86_64_linux:   "66667387399dc578ab3a9d1bbca76062f2641dbbb086328208a304acc8b0afde"
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
      --without-gdk
      --without-gtk
      --without-poppler
      --without-qt
      --without-x
      --with-freetype2
      --with-gdk-pixbuf
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
