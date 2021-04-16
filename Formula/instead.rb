class Instead < Formula
  desc "Interpreter of simple text adventures"
  homepage "https://instead.syscall.ru/"
  url "https://github.com/instead-hub/instead/archive/3.3.4.tar.gz"
  sha256 "6577235e42a22d8f7f628fedc998d718e65da9e1a3cb61f09be6d1cd648fc061"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "dd4cd0a7efdc8cc8fe7ea6c7bc85b357624167eb2f292d8fc870102253367d8f"
    sha256 big_sur:       "c027c9549578e0fbfb7258bfcfd516a4e56ed5386062151f538d2d19265a6527"
    sha256 catalina:      "6b7ab908bf9fb25b0f1196f367bef74d79d8580f032d063abd1235c66fd9fce8"
    sha256 mojave:        "028d118f6b7d3d918092c413630e4d782015ff11b7a69c63115e3ed832d8b0e2"
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
                            "-DLUA_LIBRARY=#{luajit.opt_lib}/#{shared_library("libluajit")}",
                            *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match "INSTEAD #{version} ", shell_output("#{bin}/instead -h 2>&1")
  end
end
