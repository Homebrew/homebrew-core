class Instead < Formula
  desc "Interpreter of simple text adventures"
  homepage "https://instead.hugeping.ru/"
  url "https://github.com/instead-hub/instead/archive/3.4.1.tar.gz"
  sha256 "8e61b931df2076382fe2a6857478d1d234e46db907390697656ad6754583793e"
  license "MIT"

  bottle do
    sha256 arm64_monterey: "ecb4c6f8eeb0c748f184fbf5ff989f54b6ca8942e4518353fd9864296349ef6c"
    sha256 arm64_big_sur:  "49487dd18206b1be817bcf05aa09c3dce2b17f1957b99d7a67bb05479bb8a998"
    sha256 monterey:       "edbb317d7f0f77e8250648f311e86a112be6e0fd429659fb708cf9e4f8ca23a9"
    sha256 big_sur:        "93cdfed079bf614ca0d4579ed8e7023ed26b65d4897f3889dcd7feba2a9442b6"
    sha256 catalina:       "aabf4a3da9ba905f5b565cd65fa9563de50df3dac77f671d58e7ee112f24821b"
    sha256 mojave:         "70c78465c95c5b5e2a22852af9d0ae7aa15f377dd8ef8a04f23ab0ec26fdeed1"
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
