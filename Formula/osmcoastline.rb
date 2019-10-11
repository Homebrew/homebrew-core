class Osmcoastline < Formula
  desc "Extracts coastline data from OpenStreetMap planet file"
  homepage "https://osmcode.org/osmcoastline/"
  url "https://github.com/osmcode/osmcoastline/archive/v2.2.4.tar.gz"
  sha256 "7a399661b46e4e700b11d6a5163ec7bdc8ad49f0837b524f1f2535cca7b9ee43"

  depends_on "cmake" => :build
  depends_on "libosmium" => :build
  depends_on "zlib"
  depends_on "gdal"
  depends_on "geos"
  depends_on "sqlite"
  depends_on "libspatialite"

  def install
    protozero = Formula["libosmium"].opt_libexec/"include"
    system "cmake", ".", "-DPROTOZERO_INCLUDE_DIR=#{protozero}", *std_cmake_args
    system "make", "install"
  end
end
