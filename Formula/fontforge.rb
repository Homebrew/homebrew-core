class Fontforge < Formula
  desc "Command-line outline and bitmap font editor/converter"
  homepage "https://fontforge.github.io"
  url "https://github.com/fontforge/fontforge/releases/download/20170731/fontforge-dist-20170731.tar.xz"
  sha256 "840adefbedd1717e6b70b33ad1e7f2b116678fa6a3d52d45316793b9fd808822"
  revision 3

  bottle do
    rebuild 1
    sha256 "7917392b435917468ce7f8e4c31822ba376d901cc9303ab354c44ef8155fad49" => :mojave
    sha256 "5a04540e69d56213fb104a968ad9ce2bc5c2ca152d5c3e0ecfccbd93981f80dc" => :high_sierra
    sha256 "7c4e3def1ac5f5b374e773d6dd7bda60b09eb304a19c6b231a292125d4d14915" => :sierra
  end

  option "with-extra-tools", "Build with additional font tools"

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

  # Remove for > 20170731
  # Fix "fatal error: 'mem.h' file not found" for --with-extra-tools
  # Upstream PR from 22 Sep 2017 https://github.com/fontforge/fontforge/pull/3156
  patch do
    url "https://github.com/fontforge/fontforge/commit/9f69bd0f9.patch?full_index=1"
    sha256 "f8afa9a6ab7a71650a3f013d9872881754e1ba4a265f693edd7ba70f2ec1d525"
  end

  def install
    ENV["PYTHON_CFLAGS"] = `python-config --cflags`.chomp
    ENV["PYTHON_LIBS"] = `python-config --ldflags`.chomp

    # Fix header includes to avoid crash at runtime:
    # https://github.com/fontforge/fontforge/pull/3147
    inreplace "fontforgeexe/startnoui.c", "#include \"fontforgevw.h\"", "#include \"fontforgevw.h\"\n#include \"encoding.h\""

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
    ENV.append_path "PYTHONPATH", lib/"python2.7/site-packages"
    system "python2.7", "-c", "import fontforge; fontforge.font()"
  end
end
