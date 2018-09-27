class Liblas < Formula
  desc "C/C++ library for reading and writing the LAS LiDAR format"
  homepage "https://liblas.org/"
  url "https://download.osgeo.org/liblas/libLAS-1.8.1.tar.bz2"
  sha256 "9adb4a98c63b461ed2bc82e214ae522cbd809cff578f28511122efe6c7ea4e76"
  revision 1
  head "https://github.com/libLAS/libLAS.git"

  bottle do
    sha256 "6223e1ac50e9f1f80c6ea6e219f13cd4bf82cb47757825233781cf9f99f2fb6c" => :high_sierra
    sha256 "5d699a266e2d5f32c7d75427f4810465f0e87fa7467ec6e4d5c8a4ad485f0603" => :sierra
    sha256 "a222f7c1e8b07a512a09d733c14d9fc24632a8a1188b579c34517242cf4e3c88" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "gdal"
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
    url "https://github.com/libLAS/libLAS/commit/ec10e274.diff?full_index=1"
    sha256 "3f5cc283d3e908d991b05b4dcf5cc0440824441ec270396e11738f96a0a23a9f"
  end

  needs :cxx11

  def install
    ENV.cxx11

    mkdir "macbuild" do
      # CMake finds boost, but variables like this were set in the last
      # version of this formula. Now using the variables listed here:
      #   https://liblas.org/compilation.html
      ENV["Boost_INCLUDE_DIR"] = "#{HOMEBREW_PREFIX}/include"
      ENV["Boost_LIBRARY_DIRS"] = "#{HOMEBREW_PREFIX}/lib"

      system "cmake", "..", *std_cmake_args,
                            "-DWITH_GDAL=ON",
                            "-DWITH_GEOTIFF=ON"
      system "make"
      system "make", "test" if build.bottle?
      system "make", "install"
    end
  end

  test do
    system bin/"liblas-config", "--version"
  end
end
