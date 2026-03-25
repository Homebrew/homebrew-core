class Cwal < Formula
  desc "Blazing-fast pywal-like color palette generator written in C"
  homepage "https://github.com/nitinbhat972/cwal"
  url "https://github.com/nitinbhat972/cwal/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "3a6dc4fe71e1d647d9446db978f2cc08053d44ea361df09d4343959618abf2fe"
  license "GPL-3.0-or-later"

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "imagemagick"
  depends_on "libimagequant"
  depends_on "lua"

  def install
    system "cmake", "-B", "build", "-DCMAKE_BUILD_TYPE=Release", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "bin/cwal", "--help"
  end
end
