class Liblas < Formula
  desc "C/C++ library for reading and writing the LAS LiDAR format"
  homepage "https://liblas.org/"
  url "https://download.osgeo.org/liblas/libLAS-1.8.1.tar.bz2"
  sha256 "9adb4a98c63b461ed2bc82e214ae522cbd809cff578f28511122efe6c7ea4e76"
  license "BSD-3-Clause"
  revision 3
  head "https://github.com/libLAS/libLAS.git"

  bottle do
    sha256 "c63d0d75db5b8e129c13add1de8fe94b2a38d5c15d101b62d6a7f59b796f53a3" => :catalina
    sha256 "3224d154574e4cd07837dd1d1bd3e336964e8bede4cf4bb34dbaf4a63c75ed11" => :mojave
    sha256 "b47d0b9c82040703d212e22a436b7e11aff24632f0649db959e2073e0ae48548" => :high_sierra
  end

  deprecate! date: "2018-01-01", because: :unsupported

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "libgeotiff"

  # Fix build for Xcode 9 with upstream commit
  # Remove in next version
  patch do
    url "https://github.com/libLAS/libLAS/commit/49606470.patch?full_index=1"
    sha256 "5590aef61a58768160051997ae9753c2ae6fc5b7da8549707dfd9a682ce439c8"
  end

  # Fix compilation against GDAL 2.3
  # Remove in next version
  patch do
    url "https://github.com/libLAS/libLAS/commit/ec10e274.patch?full_index=1"
    sha256 "3f8aefa1073aa32de01175cd217773020d93e5fb44a4592d76644a242bb89a3c"
  end

  def install
    ENV.cxx11

    mkdir "macbuild" do
      # CMake finds boost, but variables like this were set in the last
      # version of this formula. Now using the variables listed here:
      #   https://liblas.org/compilation.html
      ENV["Boost_INCLUDE_DIR"] = "#{HOMEBREW_PREFIX}/include"
      ENV["Boost_LIBRARY_DIRS"] = "#{HOMEBREW_PREFIX}/lib"

      system "cmake", "..", *std_cmake_args,
                            "-DWITH_GDAL=OFF",
                            "-DWITH_GEOTIFF=ON"
      system "make"
      system "make", "install"
    end
  end

  test do
    system bin/"liblas-config", "--version"
  end
end
