class Liblas < Formula
  desc "C/C++ library for reading and writing the LAS LiDAR format"
  homepage "https://liblas.org/"
  url "http://download.osgeo.org/liblas/libLAS-1.8.1.tar.bz2"
  sha256 "9adb4a98c63b461ed2bc82e214ae522cbd809cff578f28511122efe6c7ea4e76"
  head "https://github.com/libLAS/libLAS.git"

  bottle do
    sha256 "b2de49ca32280d43ac3f6d1834efd6e386297afaa070b36ef6ec0d37589e173e" => :sierra
    sha256 "d7d79cbf775119841245db9794c052a3e39cdf55fecfafcc191cd1cdcd74c61c" => :el_capitan
    sha256 "0a1c49fe8fdd82e29f2cb04c2cd7a336ad95c88f732656aac1a2bd026c4ae284" => :yosemite
  end

  option "with-test", "Verify during install with `make test`"

  depends_on "cmake" => :build
  depends_on "libgeotiff"
  depends_on "gdal"
  depends_on "boost"
  depends_on "laszip" => :optional

  def install
    mkdir "macbuild" do
      # CMake finds boost, but variables like this were set in the last
      # version of this formula. Now using the variables listed here:
      #   https://liblas.org/compilation.html
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
