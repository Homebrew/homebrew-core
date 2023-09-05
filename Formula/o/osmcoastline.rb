class Osmcoastline < Formula
  desc "Extracts coastline data from OpenStreetMap planet file"
  homepage "https://osmcode.org/osmcoastline/"
  url "https://github.com/osmcode/osmcoastline/archive/v2.4.0.tar.gz"
  sha256 "2c1a28313ed19d6e2fb1cb01cde8f4f44ece378393993b0059f447c5fce11f50"
  license "GPL-3.0-or-later"
  revision 3

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bbd332274b375390b84ade56b4fb44cd7a5c0896ebafbf6ef5764944114fd3c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87a0953864bc90e8971ccc8ff258255cebb77d677ddb946d1f4806529573ea1c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "495472ea1b183dfc23f49e2b78d75c77a5afa9a5d45277dac595da44c43c2157"
    sha256 cellar: :any_skip_relocation, ventura:        "6360a644a0079631b9e6da6540f12973b973c7de6f85f1633f502e122e7fef92"
    sha256 cellar: :any_skip_relocation, monterey:       "4b616a360a35c5c6dcaa25ec8e9a56b8d95cfdc570f3c3fd30e031e2fbc753db"
    sha256 cellar: :any_skip_relocation, big_sur:        "8099f8d01ff005e1a43d5f67afcac3f9e2474d4a1d7c56bb8e61110ed7cd4d23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44531dd7f1c5cc978fd5b6c5b27871fff3de9106acd525fbf7818556892d1092"
  end

  depends_on "cmake" => :build
  depends_on "libosmium" => :build
  depends_on "gdal"
  depends_on "geos"
  depends_on "libspatialite"
  depends_on "lz4"

  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  fails_with gcc: "5"

  # To fix gdal-3.7.0
  patch do
    url "https://github.com/osmcode/osmcoastline/commit/67cc33161069f65e315acae952492ab5ee07af15.patch?full_index=1"
    sha256 "31b89e33b22ccdfe289a5da67480f9791bdd4f410c6a7831f0c1e007c4258e68"
  end

  def install
    protozero = Formula["libosmium"].opt_libexec/"include"
    system "cmake", ".", "-DPROTOZERO_INCLUDE_DIR=#{protozero}", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"input.opl").write <<~EOS
      n100 v1 x1.01 y1.01
      n101 v1 x1.04 y1.01
      n102 v1 x1.04 y1.04
      n103 v1 x1.01 y1.04
      w200 v1 Tnatural=coastline Nn100,n101,n102,n103,n100
    EOS
    system "#{bin}/osmcoastline", "-v", "-o", "output.db", "input.opl"
  end
end
