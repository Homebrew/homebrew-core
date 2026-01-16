class Instead < Formula
  desc "Interpreter of simple text adventures"
  homepage "https://instead.hugeping.ru/"
  url "https://github.com/instead-hub/instead/archive/refs/tags/3.5.2.tar.gz"
  sha256 "589f80cbac9edf51b29d86e1528b9e72c576129fa5c95f1bac3e5bb25c210cf3"
  license "MIT"

  bottle do
    sha256 arm64_tahoe:    "53f279e0d364f5217e47b9da552243cf46ab2d21e9ec606d180b69e9b82ff7b3"
    sha256 arm64_sequoia:  "b27debf30bd17c51b94f24b9aed4d2a5be840d0af7a177bf32b6ad9e65221f6c"
    sha256 arm64_sonoma:   "1387c5811cd5a12673f7c9ad9e0e53f1805cd4510112b4a348912d711f07d745"
    sha256 arm64_ventura:  "a787fd3c5152c2c083ac5a5ecf474649d6e84ed5b49f8b4ea02681161ad57676"
    sha256 arm64_monterey: "66f51dc5e4e785ea0c15e11a7ff63a0bd42bd9fbde2113cb8eb31100147b86e9"
    sha256 sonoma:         "b923b24f39f86b55e4ea5e85570c83927dbc0fa96fa0edab5a2fcf0ca77c3c9a"
    sha256 ventura:        "33d4f677954750c9bb4f4bf48cd36720bc80ae91e9a1be16c766cc1d9629f3b6"
    sha256 monterey:       "b3bd5654c3d4e24858569437b6aad9dea3c568bf014abb94202e2f4e73f0d9dd"
    sha256 arm64_linux:    "88fcd069cad40be6a02b4b34c859f9132bc5961fcbf22e522aeac5017b412cf6"
    sha256 x86_64_linux:   "06bea67b1d7d82de33cf429134b9f001bfd1a788ad10bbf61d666f10a1a18e1f"
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

  uses_from_macos "zlib"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "cairo"
    depends_on "gettext"
    depends_on "harfbuzz"
    depends_on "pango"
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
