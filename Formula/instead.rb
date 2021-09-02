class Instead < Formula
  desc "Interpreter of simple text adventures"
  homepage "https://instead.hugeping.ru/"
  url "https://github.com/instead-hub/instead/archive/3.4.0.tar.gz"
  sha256 "e69d73a97a846920ee11109e22332b46008117542bd5298ef3c1f4966ed5c604"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "e6e268294d2e4b933f453d1aeb5ad801d59ab8ef8144ec399e8a6102e39708ec"
    sha256 big_sur:       "ffa9dcb750b0f27eef50b6355576611b5f277703b5ff00e14b19902efc41198e"
    sha256 catalina:      "52a08ffd79ed516f100689cf22dcbb2dc6aac7226a0aa2799db5d71796e66402"
    sha256 mojave:        "3fe9ec0aff8e487fdb3685c6e00793b8922b5fb80ad62e7a4b48ae4d8b4cf51f"
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
