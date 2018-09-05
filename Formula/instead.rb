class Instead < Formula
  desc "Interpreter of simple text adventures"
  homepage "https://instead.syscall.ru/"
  url "https://github.com/instead-hub/instead/archive/3.2.1.tar.gz"
  sha256 "2f5ee94393cf9f314bd9a8617a7f16d6500376223b920bf1821ba0e8a76c3696"

  bottle do
    rebuild 1
    sha256 "04bb5aa8a156e7d0283aa3358d0af17f77d93db023f909e1db33c7d09872be38" => :mojave
    sha256 "e34be5357b1fc1991909eb42be7375051751377b84fd2b7d8466012d925dec8a" => :high_sierra
    sha256 "88a1e5c494bd2266afe16353f992c5143e59cb0acfd85e80d2cc5cea03f4065e" => :sierra
    sha256 "b665c852c5c0fd894e0a9d84e99a5cc8e1a21699e8dfe48dd2d5110d6f3d201b" => :el_capitan
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
