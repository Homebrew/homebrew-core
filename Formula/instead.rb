class Instead < Formula
  desc "Interpreter of simple text adventures"
  homepage "https://instead.hugeping.ru/"
  url "https://github.com/instead-hub/instead/archive/3.5.0.tar.gz"
  sha256 "28b2bda81938106393d2ca190be9d95c862189c8213e4b6dee3a913e2aae2620"
  license "MIT"
  revision 1

  bottle do
    sha256 arm64_monterey: "54d5cf80499e6b088700d8119db84f1d8048c834e89f82e47c61b1193f025fdc"
    sha256 arm64_big_sur:  "0480c3df8d3323dcb726cc0d2f41777fcb4bffc4b4421ece7fede026fb4081f2"
    sha256 monterey:       "f9e9e0b7cbf22ce2330482803f8e626b6b573aad906ba53fd8fa2daca2196b0e"
    sha256 big_sur:        "6d22aa39da7ad83aea389238a8460dd4de12e8511b40b0fdc317342a589a5bf6"
    sha256 catalina:       "7ebd1d27964ee2215db0924f53f997667bb3102956603f97f086e50a01e1a5c5"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gtk+3"
  depends_on "luajit"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"
  depends_on "sdl2_ttf"

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
