class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://graphviz.org/"
  url "https://gitlab.com/api/v4/projects/4207231/packages/generic/graphviz-releases/14.1.1/graphviz-14.1.1.tar.xz"
  sha256 "a786db0c32a5b96e1b7c06b0bcfffe901cba601a6de2d5f365e9132ac88d36b1"
  license "EPL-1.0"
  version_scheme 1

  livecheck do
    url "https://graphviz.org/download/source/"
    regex(/href=.*?graphviz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "3bf56d5aebfdd3aa87ef9a8a3ba07bdc9543e25248f9fa7445137e6eb009aac6"
    sha256 arm64_sequoia: "d971c776efe727c6b0062a82f6d53c1285a4895415d3a3e44c15aaf63f4123e7"
    sha256 arm64_sonoma:  "664a9525447c8f2e4a46c93f3601b84ec0ef7b6bde3f9c3ecd86ec59955138c0"
    sha256 sonoma:        "11bd813376679b5fbe99d6afa75998f552fe5c6d870f83b20aebe2286fdfe4b1"
    sha256 arm64_linux:   "32b6d83e35da118997251b057e13712a06bd71c0d507a377f6448f555f790f86"
    sha256 x86_64_linux:  "2affeeb9ac5abec9effb3a0c29dfe5e61c9dcd0de8e4d3d6d0170fc3f8d0cd3d"
  end

  head do
    url "https://gitlab.com/graphviz/graphviz.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "bison" => :build
  depends_on "pkgconf" => :build
  depends_on "cairo"
  depends_on "gd"
  depends_on "glib"
  depends_on "gts"
  depends_on "libpng"
  depends_on "librsvg"
  depends_on "libtool"
  depends_on "pango"
  depends_on "webp"

  uses_from_macos "flex" => :build
  uses_from_macos "python" => :build
  uses_from_macos "expat"
  uses_from_macos "zlib"

  on_macos do
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "gdk-pixbuf"
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  def install
    args = %w[
      --disable-silent-rules
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

    system "./autogen.sh" if build.head?
    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"sample.dot").write <<~EOS
      digraph G {
        a -> b
      }
    EOS

    system bin/"dot", "-Tpdf", "-o", "sample.pdf", "sample.dot"
  end
end
