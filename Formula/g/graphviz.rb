class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://graphviz.org/"
  url "https://gitlab.com/api/v4/projects/4207231/packages/generic/graphviz-releases/13.0.1/graphviz-13.0.1.tar.xz"
  sha256 "eabb50ea256165a072e99c46a00cce9cb9063b6bf6b3bd8e088c9855212b664a"
  license "EPL-1.0"
  version_scheme 1

  livecheck do
    url "https://graphviz.org/download/source/"
    regex(/href=.*?graphviz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "0504bffeb09f1ca814c2a17662a622a202c75d2a686ba59e46e079dc5e892710"
    sha256 arm64_sonoma:  "f9362747dde78f31b20943f159a1abbe4b8ab68c5fb79fc36cae30af588ff309"
    sha256 arm64_ventura: "1cc0f412e9b8ce4b8427b9def0960e23ef11fdf11516dc3441a12639175e75ab"
    sha256 sonoma:        "8c8bbe253944e0c3967c95ccc7610cff32d0645ec8dfd75499694aefc8eb892d"
    sha256 ventura:       "f1066a6748a3e099d4823019ff3f276685602f9032fff42957aa15635adf9226"
    sha256 arm64_linux:   "49855d083644b9ec657e6e9ddd5dd9587e372a3dc0f298557ac1fa70140dfbbe"
    sha256 x86_64_linux:  "4fa7a552f880d941025f3d354f7720b494be553f28a8c277a2822f35c2b0e7d9"
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
