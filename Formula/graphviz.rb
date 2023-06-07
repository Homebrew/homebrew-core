class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://graphviz.org/"
  url "https://gitlab.com/graphviz/graphviz.git",
      tag:      "8.0.5",
      revision: "7bdda21f9e7877c2af653f82246bc4f62151b6a2"
  license "EPL-1.0"
  version_scheme 1
  head "https://gitlab.com/graphviz/graphviz.git", branch: "main"

  bottle do
    sha256 arm64_ventura:  "d9351344fe61bdb7f13f7feb1c945e24aae266391d73589560e191602f87557f"
    sha256 arm64_monterey: "7d46d02c8d06b5b95289d3a9f7a85c06b5b65e354c54d36d043155778280c2c3"
    sha256 arm64_big_sur:  "88c22a66b8affffe80721b4e245d5411e10ef48dff1ec5031910cf4a4f70c7e0"
    sha256 ventura:        "48a715d0a65907dbc07ce82d92da156d569476dff15b3b9301232e99430fbeba"
    sha256 monterey:       "21dedd997a0fc0a32b8e41ba64627668d144622775421e475ce0e9dda468d853"
    sha256 big_sur:        "4cada6d6a7344b0a77ef9948861df661f0c7c13de9264eaa2c7cb6e3a26016d1"
    sha256 x86_64_linux:   "7e44572dcffd7f2538725ad2efb4743777d17e4eb44a58110d5fb9cf6af41da1"
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
