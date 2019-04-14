class Fontforge < Formula
  desc "Command-line outline and bitmap font editor/converter"
  homepage "https://fontforge.github.io"
  url "https://github.com/fontforge/fontforge/releases/download/20190413/fontforge-20190413.tar.gz"
  sha256 "6762a045aba3d6ff1a7b856ae2e1e900a08a8925ccac5ebf24de91692b206617"

  bottle do
    cellar :any
    sha256 "51ef34cecd1526a22d2d5aec263743414275cff625c2bce2dc42a4afcff2e31a" => :mojave
    sha256 "cd656977573422e787358948cb6be584e491965e364521a89d964265698efcb2" => :high_sierra
    sha256 "a80147c5a5c73950e03dae4615571905156170cc97df40ce85231894195f79b8" => :sierra
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
