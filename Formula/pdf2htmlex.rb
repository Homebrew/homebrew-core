class Pdf2htmlex < Formula
  desc "PDF to HTML converter"
  homepage "https://coolwanglu.github.io/pdf2htmlEX/"
  url "https://github.com/coolwanglu/pdf2htmlEX/archive/v0.14.6.tar.gz"
  sha256 "320ac2e1c2ea4a2972970f52809d90073ee00a6c42ef6d9833fb48436222f0e5"
  license "GPL-3.0-or-later"
  revision 24
  head "https://github.com/coolwanglu/pdf2htmlEX.git", branch: "master"

  bottle do
    sha256 arm64_big_sur: "8c29d3c811e6e6580644620a76848458db39181b996cc15e4df2589c8de40e27"
    sha256 big_sur:       "7cb1691e750ce40dfc9dbb9e9faba3138158c31e3221335acd3d4f25eb7bf3c3"
    sha256 catalina:      "76c5b16da33231ee6d269f95c5b9b3f0f06b9f5d5634e003d55e6ad5e123a387"
    sha256 mojave:        "0cf6aa3cd87e96aab2fc58b618f8a9127edec88a624bd6cf2f5816fd575c0a50"
    sha256 high_sierra:   "8a55a7cd0d373d223162ee92bc6f02c269b4f17fe987471ba3388ea257cf870f"
  end

  deprecate! date: "2016-12-12", because: :repo_archived

  depends_on "autoconf" => :build # for fontforge
  depends_on "automake" => :build # for fontforge
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo" # for fontforge
  depends_on "freetype" # for fontforge
  depends_on "gettext" # for fontforge
  depends_on "giflib" # for fontforge
  depends_on "glib" # for fontforge
  depends_on "gnu-getopt"
  depends_on "jpeg" # for fontforge
  depends_on "libpng" # for fontforge
  depends_on "libtiff" # for fontforge
  depends_on "libtool" # for fontforge

  depends_on "openjpeg" # for poppler
  depends_on "pango" # for fontforge
  depends_on "ttfautohint"

  # Pdf2htmlex use an outdated, customised Fontforge installation.
  # See https://github.com/coolwanglu/pdf2htmlEX/wiki/Building
  resource "fontforge" do
    url "https://github.com/coolwanglu/fontforge.git", branch: "pdf2htmlEX"
  end

  # Upstream issue "poppler 0.59.0 incompatibility"
  # Reported 4 Sep 2017 https://github.com/coolwanglu/pdf2htmlEX/issues/733
  resource "poppler" do
    url "https://poppler.freedesktop.org/poppler-0.57.0.tar.xz"
    sha256 "0ea37de71b7db78212ebc79df59f99b66409a29c2eac4d882dae9f2397fe44d8"
  end

  resource "poppler-data" do
    url "https://poppler.freedesktop.org/poppler-data-0.4.8.tar.gz"
    sha256 "1096a18161f263cccdc6d8a2eb5548c41ff8fcf9a3609243f1b6296abdf72872"
  end

  def install
    resource("fontforge").stage do
      # Fix for incomplete giflib 5 support, see
      # https://github.com/coolwanglu/pdf2htmlEX/issues/713
      inreplace "gutils/gimagereadgif.c", "DGifCloseFile(gif)", "DGifCloseFile(gif, NULL)"

      if OS.mac?
        # Fix linker error; see: https://trac.macports.org/ticket/25012
        ENV.append "LDFLAGS", "-lintl"
      end

      system "./autogen.sh"
      system "./configure", "--prefix=#{libexec}/fontforge",
                            "--without-libzmq",
                            "--without-x",
                            "--without-iconv",
                            "--without-libspiro",
                            "--without-libuninameslist",
                            "--disable-python-scripting",
                            "--disable-python-extension"
      system "make"
      system "make", "install"
    end

    ENV.prepend_path "PKG_CONFIG_PATH", "#{libexec}/fontforge/lib/pkgconfig"
    ENV.prepend_path "PATH", "#{libexec}/fontforge/bin"

    resource("poppler").stage do
      inreplace "poppler.pc.in", "Cflags: -I${includedir}/poppler",
                                 "Cflags: -I${includedir}/poppler -I${includedir}"

      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{libexec}/poppler",
                            "--enable-xpdf-headers",
                            "--enable-poppler-glib",
                            "--disable-gtk-test",
                            "--enable-introspection=no",
                            "--disable-poppler-qt4"
      system "make", "install"
      resource("poppler-data").stage do
        system "make", "install", "prefix=#{libexec}/poppler"
      end
    end

    ENV.prepend_path "PKG_CONFIG_PATH", "#{libexec}/poppler/lib/pkgconfig"
    ENV.prepend_path "PATH", "#{libexec}/poppler/bin"

    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/pdf2htmlEX", test_fixtures("test.pdf")
  end
end
