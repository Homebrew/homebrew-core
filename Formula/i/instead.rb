class Instead < Formula
  desc "Interpreter of simple text adventures"
  homepage "https://instead.hugeping.ru/"
  url "https://github.com/instead-hub/instead/archive/refs/tags/3.5.2.tar.gz"
  sha256 "589f80cbac9edf51b29d86e1528b9e72c576129fa5c95f1bac3e5bb25c210cf3"
  license "MIT"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "c2466f19712599960fdf617de00a5c87e31419ce1ab9e83a28fc67ea433a0956"
    sha256 arm64_sequoia: "a30498f22007194b3d1fde6afb2b2e3ad5a5cef5a7a763f477c26cc625a44fba"
    sha256 arm64_sonoma:  "631b5131f25ddaf10acbf42922cddf3996561d00e53ec60eafb2f782683a6834"
    sha256 sonoma:        "055fa879171dbd50e4234937229b42b16073c1bd4e85ea0be5287735f30eb4b3"
    sha256 arm64_linux:   "37c0dbb0fad67fe9883639294c3b63c150900e8d7af0d36277c021f10af1c8b3"
    sha256 x86_64_linux:  "e188ffae06055d161cb807e5a814a2fe2a60604964436b2e4efd835d7e68b747"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "luajit"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"
  depends_on "sdl2_ttf"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "cairo"
    depends_on "gettext"
    depends_on "harfbuzz"
    depends_on "pango"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5",
                    "-DWITH_GTK2=OFF",
                    "-DWITH_LUAJIT=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "INSTEAD #{version} ", shell_output("#{bin}/instead -h 2>&1")
  end
end
