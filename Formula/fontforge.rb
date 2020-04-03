class Fontforge < Formula
  desc "Command-line outline and bitmap font editor/converter"
  homepage "https://fontforge.github.io"
  url "https://github.com/fontforge/fontforge/releases/download/20200314/fontforge-20200314.tar.xz"
  sha256 "cd190b237353dc3f48ddca7b0b3439da8ec4fcf27911d14cc1ccc76c1a47c861"

  bottle do
    cellar :any
    sha256 "5491094eb17337498a90804ce72fd154cdf643272467312a9dc1cfc1f5e56a82" => :catalina
    sha256 "ceade22a6cbbecff190fedd4be117cfce9c6036c20a51de701f82a69cd0343a5" => :mojave
    sha256 "0e91f1858662fa08537287af6e1884ef94377a46a5eb24cec61f3f9f41c48e8a" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gettext"
  depends_on "giflib"
  depends_on "glib"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libspiro"
  depends_on "libtiff"
  depends_on "libtool"
  depends_on "libuninameslist"
  depends_on "pango"
  depends_on "python@3.8"
  depends_on "readline"
  uses_from_macos "libxml2"

  def install
    mkdir "build" do
      system "cmake", "..", "-DENABLE_GUI=OFF",
                            "-DENABLE_FONTFORGE_EXTRAS=ON",
                            *std_cmake_args
      system "make", "install"

      # The "extras" built above don't get installed by default.
      bin.install Dir["bin/*"].select { |f| File.executable? f }
    end
  end

  def caveats
    <<~EOS
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
    xy = Language::Python.major_minor_version "python3@3.8"
    ENV.append_path "PYTHONPATH", lib/"python#{xy}/site-packages"
    system "#{Formula["python@3.8"].opt_bin}/python3", "-c", "import fontforge; fontforge.font()"
  end
end
