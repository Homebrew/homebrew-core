class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://graphviz.org/"
  url "https://gitlab.com/graphviz/graphviz.git",
      tag:      "10.0.1",
      revision: "1c6cb9d3de553bd3e3caeea9a61ebe04034d07ee"
  license "EPL-1.0"
  version_scheme 1
  head "https://gitlab.com/graphviz/graphviz.git", branch: "main"

  bottle do
    sha256 arm64_sonoma:   "cd3b730ae9b021a1b7886c497768ce9fcd84ef5e7d3e6ef273cbbe344e905942"
    sha256 arm64_ventura:  "3a2ac0138232cf948240a29f6b3d97be76ad4f205e6a348422b82ff33363340a"
    sha256 arm64_monterey: "cf6fa16e7335f4b43dc048f2d96f79f4d7887c1f950f5e30400182e88269cb56"
    sha256 sonoma:         "bc4ae8de4c2ede705cd36568af374ad3c0c09650737ee0a37050aff0bb1352c9"
    sha256 ventura:        "c1f6d8228bf45eee693f2051502065d9dc7cfb34dcab8a84a3b4854d633a18a7"
    sha256 monterey:       "f6195c6478489a9da5fdff1d51ae435e1588c722710d7095561586a3072f8375"
    sha256 x86_64_linux:   "c11a32bd38397c396ec46cbffa45356d095fa16004b000510a4e8c09d839f175"
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
