class Liblas < Formula
  desc "C/C++ library for reading and writing the LAS LiDAR format"
  homepage "https://liblas.org/"
  url "http://download.osgeo.org/liblas/libLAS-1.8.1.tar.bz2"
  sha256 "9adb4a98c63b461ed2bc82e214ae522cbd809cff578f28511122efe6c7ea4e76"
  head "https://github.com/libLAS/libLAS.git"

  bottle do
    rebuild 1
    sha256 "2931404e7478d7ebc2bcb898b0c6985dabe7b74d8d60ed6bc2c75b3952decfed" => :high_sierra
    sha256 "18d1e55ca381414ca41bce0c8478cd5793b467c0161a01a3ae111a572083d3a0" => :sierra
    sha256 "d4e63dbad2a70fb8fcab57a93d6013cb1048e247ede3d6101334dfc6dba249c5" => :el_capitan
  end

  option "with-test", "Verify during install with `make test`"

  depends_on "cmake" => :build
  depends_on "libgeotiff"
  depends_on "gdal"
  depends_on "boost"
  depends_on "laszip" => :optional

  # Fix build for Xcode 9 with upstream commit
  # Remove in next version
  patch do
    url "https://github.com/libLAS/libLAS/commit/49606470.patch?full_index=1"
    sha256 "5590aef61a58768160051997ae9753c2ae6fc5b7da8549707dfd9a682ce439c8"
  end

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
