class Instead < Formula
  desc "Interpreter of simple text adventures"
  homepage "https://instead.hugeping.ru/"
  url "https://github.com/instead-hub/instead/archive/refs/tags/3.5.1.tar.gz"
  sha256 "53380f94be7f1ec46de309d513f7fe62a1c63d607a247715d87815e83a9c7d63"
  license "MIT"
  revision 1

  bottle do
    sha256 arm64_sonoma:   "71ac2a3f9df4d5ca2edd62c7976d058bbfbd8e7f68360055a779505e8a59d7e9"
    sha256 arm64_ventura:  "9261abc6caf12141ca3d0b491959cc949c682de5dfaad1dab9b34575496d0939"
    sha256 arm64_monterey: "b2fd66063eaa0bc277240aa16b8ff43ad20dc77db674d6cde03abad2b328aee3"
    sha256 sonoma:         "efb9d9734907b7fdf04273dbdefe9429ed39ce0e8d1914baa47ca97f598a3fff"
    sha256 ventura:        "2ebf2f27fa41788ce3bbcb0ec16cd696196a1a31cbba63526c8e858105611e10"
    sha256 monterey:       "fd4f2bcdce248746df7ba6fa325b4cf6175c1e4e193bd5f540d65cd8aeb04eaf"
    sha256 x86_64_linux:   "9ae0b409809658af1bc41fd1784e56e26fc5c5ba84d647979826bb8b64c4f3db"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
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
