class Instead < Formula
  desc "Interpreter of simple text adventures"
  homepage "https://instead.syscall.ru/"
  url "https://github.com/instead-hub/instead/archive/3.3.3.tar.gz"
  sha256 "1425c559ab91c8ec3e02ad74f6989a4408ee7141d69361d17aeff174d194fe57"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "37dcf9170b3706a2e998d5b9c6656786bfab4745e0d59cc0f4e9cc79bcec4fe7"
    sha256 big_sur:       "1ccae5373dd3a5fb4bb1031f56bfa9f55b50077c63512d3a3c90a3e02c71dadc"
    sha256 catalina:      "c45adcc385d4034b861366b7420c6ab8d699e485fa2c0f7184fa87fc9de3f717"
    sha256 mojave:        "68beec5c7fe7fa252265ac54f08c3a612f51e5d0aac0890a72bef42b06a07919"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gtk+3"
  depends_on "luajit-openresty"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"
  depends_on "sdl2_ttf"

  def install
    luajit = Formula["luajit-openresty"]
    mkdir "build" do
      system "cmake", "..", "-DWITH_GTK2=OFF",
                            "-DWITH_LUAJIT=ON",
                            "-DLUA_INCLUDE_DIR=#{luajit.opt_include}/luajit-2.1",
                            "-DLUA_LIBRARY=#{luajit.opt_lib}/libluajit.dylib",
                            *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match "INSTEAD #{version} ", shell_output("#{bin}/instead -h 2>&1")
  end
end
