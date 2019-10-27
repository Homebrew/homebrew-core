class Libxdf < Formula
  desc "C++ library for loading XDF files"
  homepage "https://github.com/Yida-Lin/libxdf"
  url "https://github.com/xdf-modules/libxdf/archive/v0.99.tar.gz"
  sha256 "af66f6c1be5d9342fa33bc2a3b34c5a962db37d10623df57d352a213fe5201d1"

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make"

    include.mkpath
    include.install "./xdf.h"
    lib.mkpath
    lib.install "libxdf.dylib"
    lib.install "libxdf.a"
  end

  test do
    system "ls", "#{lib}/libxdf.dylib"
  end
end
