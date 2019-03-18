class Fontforge < Formula
  desc "Command-line outline and bitmap font editor/converter"
  homepage "https://fontforge.github.io"
  url "https://github.com/fontforge/fontforge/releases/download/20190317/fontforge-20190317.tar.gz"
  sha256 "b711adec0da9ee490bbc2698b33e6630150931e08e826d1b63eb3131d85db8b5"

  bottle do
    cellar :any
    sha256 "e7fa8b8ce7845a1638d9fcb4c48ac515ee6981a2306b9d2c6d54c699f45e9b57" => :mojave
    sha256 "035977f787460dfd0f0fbe748b62bfaf6b3ea1289e62508a1e1348e40a0126d9" => :high_sierra
    sha256 "8537403a86247c52d300b55a24a0528ad79abf9a07eccd16fdcbd84a7361e9f6" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "gettext"
  depends_on "giflib"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libspiro"
  depends_on "libtiff"
  depends_on "libtool"
  depends_on "libuninameslist"
  depends_on "pango"
  depends_on "python@2"

  def install
    ENV["PYTHON_CFLAGS"] = `python-config --cflags`.chomp
    ENV["PYTHON_LIBS"] = `python-config --ldflags`.chomp

    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--without-x"
    system "make", "install"

    # The app here is not functional.
    # If you want GUI/App support, check the caveats to see how to get it.
    (pkgshare/"osx/FontForge.app").rmtree

    # Build extra tools
    cd "contrib/fonttools" do
      system "make"
      bin.install Dir["*"].select { |f| File.executable? f }
    end
  end

  def caveats; <<~EOS
    This formula only installs the command line utilities.

    FontForge.app can be downloaded directly from the website:
      https://fontforge.github.io

    Alternatively, install with Homebrew Cask:
      brew cask install fontforge
  EOS
  end

  test do
    system bin/"fontforge", "-version"
    system bin/"fontforge", "-lang=py", "-c", "import fontforge; fontforge.font()"
    xy = Language::Python.major_minor_version "python"
    ENV.append_path "PYTHONPATH", lib/"python#{xy}/site-packages"
    system "python", "-c", "import fontforge; fontforge.font()"
  end
end
