class Liblas < Formula
  desc "C/C++ library for reading and writing the LAS LiDAR format"
  homepage "http://liblas.org"
  url "http://download.osgeo.org/liblas/libLAS-1.8.0.tar.bz2"
  sha256 "17310082845e45e5c4cece78af98ee93aa5d992bf6d4ba9a6e9f477228738d7a"
  revision 2

  head "https://github.com/libLAS/libLAS.git"

  bottle do
    sha256 "80e1a3f5d9f7ede5fc6f4ddd4a7b68144fdd72a09fba7b3b49c6dd24a0241cf9" => :sierra
    sha256 "8874664ed1d3ddbd1bfd84e2f7cf60c04f940ff7b893db3f07759cacae0e68fb" => :el_capitan
    sha256 "d50ad495d6ee1081ec857374fa72fa9f0eae2f861ff41760922aa437ec45acd8" => :yosemite
    sha256 "d7d6cf27f274a7ec08dee5a4dbceb7156e2f9fab989a002ff4c6687146f042e5" => :mavericks
    sha256 "c628a4cd7a2904e9536b494f9ad015046184ae2b44c5ab7bbc662e43f844b6c5" => :mountain_lion
  end

  option "with-test", "Verify during install with `make test`"

  depends_on "cmake" => :build
  depends_on "libgeotiff"
  depends_on "gdal"
  depends_on "boost@1.61"
  depends_on "laszip" => :optional

  def install
    mkdir "macbuild" do
      # CMake finds boost, but variables like this were set in the last
      # version of this formula. Now using the variables listed here:
      #   http://liblas.org/compilation.html
      ENV["Boost_INCLUDE_DIR"] = "#{HOMEBREW_PREFIX}/include"
      ENV["Boost_LIBRARY_DIRS"] = "#{HOMEBREW_PREFIX}/lib"
      args = ["-DWITH_GEOTIFF=ON", "-DWITH_GDAL=ON"] + std_cmake_args
      args << "-DWITH_LASZIP=ON" if build.with? "laszip"

      system "cmake", "..", *args
      system "make"
      system "make", "test" if build.bottle? || build.with?("test")
      system "make", "install"
    end
  end

  test do
    system bin/"liblas-config", "--version"
  end
end
