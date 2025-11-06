class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://graphviz.org/"
  url "https://gitlab.com/api/v4/projects/4207231/packages/generic/graphviz-releases/14.0.2/graphviz-14.0.2.tar.xz"
  sha256 "31af4728cd0d7db91013d29286227ae6b5264ff897647c2ebfeb85f47c08177e"
  license "EPL-1.0"
  version_scheme 1

  livecheck do
    url "https://graphviz.org/download/source/"
    regex(/href=.*?graphviz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "22e300b506629d228c066a287c1bfc8f5261f4255597353fb11ea662462e548a"
    sha256 arm64_sequoia: "9d94b5765b75e1dc569cffdff90659d71ace0a3262ae14aec39080e0ddb0717d"
    sha256 arm64_sonoma:  "6f3bd83a592e321a85ac4c05cff0ada14212ba0d75202222e01f1a608bb04cdd"
    sha256 sonoma:        "54fb0df64204b991cc424aee0ea9ca65c52acf21f0410f9f21542c3fe940dfcc"
    sha256 arm64_linux:   "9269b27985b9f5196f64bd5560c1715bfeecdb3b1af277df0b8cb02a8b46a32d"
    sha256 x86_64_linux:  "1629d02edf622f0882e703698d5bc520311c687dd6adc35dde163a4b47043e6d"
  end

  head do
    url "https://gitlab.com/graphviz/graphviz.git", branch: "main"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "aalib"
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
    if build.head?
      # CMake build for HEAD (includes aalib ASCII art support)
      args = %W[
        -DENABLE_PHP=OFF
        -DENABLE_SWIG=OFF
        -DENABLE_TCL=OFF
        -DWITH_POPPLER=OFF
        -DWITH_QT=OFF
      ]

      args << "-DWITH_QUARTZ=ON" if OS.mac?

      system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    else
      # Autotools build for stable release
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

      system "./configure", *args, *std_configure_args
      system "make"
      system "make", "install"
    end
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
