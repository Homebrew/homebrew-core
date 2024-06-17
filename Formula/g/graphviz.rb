class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://graphviz.org/"
  url "https://gitlab.com/graphviz/graphviz.git",
      tag:      "11.0.0",
      revision: "b6b3d533b8b67b61dd662c5d7cb1bec590f9f3d0"
  license "EPL-1.0"
  version_scheme 1
  head "https://gitlab.com/graphviz/graphviz.git", branch: "main"

  bottle do
    sha256 arm64_sonoma:   "29eb1e32e80a89d08d97932fcd82105deae9ef6d84d22811b5e9190417600deb"
    sha256 arm64_ventura:  "5e3d22decb0cc58b4952bd9cb41621b603d832d025de3f35d15d78c6042b3703"
    sha256 arm64_monterey: "b850f16b57112308d3244ef07764c4787f437751ac07fa7a1d64e9589309199b"
    sha256 sonoma:         "c61311aefb20279fca68ee60b4a455381db6433b9e126707d294dbdf2e9add2d"
    sha256 ventura:        "e0a790680fbfa22a93b1fc73c7e6f5ca71bc115dacb84cfbf9409c80ee16ec89"
    sha256 monterey:       "bc67e4cb1889c29730b4ccfae7cbf82b796c91481bd99ffbccd06cdccfff6b06"
    sha256 x86_64_linux:   "25cc32990dded2f7d7351834cc39d8e41b05e62142a6e5f6b8d788c8d56ec784"
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
