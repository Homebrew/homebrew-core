class Instead < Formula
  desc "Interpreter of simple text adventures"
  homepage "https://instead.syscall.ru/"
  url "https://github.com/instead-hub/instead/archive/3.3.1.tar.gz"
  sha256 "3b5e4cb7ce965e89a3906787791919d475834001438d10c46b77085f2e8767ea"

  bottle do
    sha256 "8e05330df7054b69d5696ba00bbf4bb438cbd35b175f5a745e80c7b0095dec73" => :mojave
    sha256 "0eaf8c4d40fcd870575d99c5359e6fecc15d539707e6ddbe9065ee0f31e141ac" => :high_sierra
    sha256 "78f59e3c2455fe4be63ec3ea079c4afcd9a3e5f7ff8d5de90b4e2fa1e401db9a" => :sierra
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
