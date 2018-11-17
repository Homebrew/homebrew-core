class Instead < Formula
  desc "Interpreter of simple text adventures"
  homepage "https://instead.syscall.ru/"
  url "https://github.com/instead-hub/instead/archive/3.2.2.tar.gz"
  sha256 "796d796101561a452ac409f46ba4a53ecb3b4ef19694b573def7d3fc09a1a865"

  bottle do
    sha256 "add19bed963319edd7d9f0aca6067d3d4abe426799ab6c961fb5201ea04a544d" => :mojave
    sha256 "79b9e11c1749ab06bc53edc9a928bb69221faf1b25a8b5c27c7894233d5aaf65" => :high_sierra
    sha256 "52e9c04ec3c20811f17ccccfab3bf43713385f63934943da4439d23cfbb4d8c5" => :sierra
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
                            "-DLUA_INCLUDE_DIR=#{Formula["lua"].opt_include}/lua",
                            "-DLUA_LIBRARY=#{Formula["lua"].opt_lib}/liblua.dylib",
                            *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match /INSTEAD #{version} /, shell_output("#{bin}/instead -h 2>&1")
  end
end
