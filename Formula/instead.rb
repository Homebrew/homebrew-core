class Instead < Formula
  desc "Interpreter of simple text adventures"
  homepage "https://instead.syscall.ru/"
  url "https://github.com/instead-hub/instead/archive/3.2.1.tar.gz"
  sha256 "2f5ee94393cf9f314bd9a8617a7f16d6500376223b920bf1821ba0e8a76c3696"

  bottle do
    sha256 "a0a3ea00027270c2e2c187875cf0d927ea3774e9d15cecc22ad79a71f5a4055d" => :high_sierra
    sha256 "553fe8895598076f95471f287dc1de07833015eaf1cb0458a68a520c842270b2" => :sierra
    sha256 "6dfd28908d6b1106557b956999bc80a98918ccd5f0b97089748c087b2c4bd7be" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "lua"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"
  depends_on "sdl2_ttf"

  # Remove for > 3.2.1
  # Fix undefined symbols errors for _CFBundleCopyResourcesDirectoryURL etc.
  # Upstream commit from 22 Apr 2018 "CMake: link AppKit framework on macOS"
  patch do
    url "https://github.com/instead-hub/instead/commit/e00be1e2.patch?full_index=1"
    sha256 "63213ebeb0136f5388edfc8d7f240282a225ce73ea50ff89b319282556551d74"
  end

  def install
    mkdir "build" do
      system "cmake", "..", "-DWITH_GTK2=OFF",
                            "-DLUA_INCLUDE_DIR=#{Formula["lua"].opt_include}",
                            "-DLUA_LIBRARY=#{Formula["lua"].opt_lib}/liblua.dylib",
                            *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match /INSTEAD #{version} /, shell_output("#{bin}/instead -h 2>&1")
  end
end
