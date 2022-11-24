class NetcdfCxx < Formula
  desc "C++ libraries and utilities for NetCDF"
  homepage "https://www.unidata.ucar.edu/software/netcdf/"
  url "https://github.com/Unidata/netcdf-cxx4/archive/refs/tags/v4.3.1.tar.gz"
  sha256 "e3fe3d2ec06c1c2772555bf1208d220aab5fee186d04bd265219b0bc7a978edc"
  license "NetCDF"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b8249b9ab11997990d8ecba6a47b57b4a5df1e6aad825f17f0ad00ad23a85b7d"
    sha256 cellar: :any,                 arm64_monterey: "14fb172c409bda5dc90e97e7696346cde6907b74a8e282579b0d7a96486d7c6f"
    sha256 cellar: :any,                 arm64_big_sur:  "36523f3a017dfc37063d39b7b266258ed6fcc72cd1062a03ef6fa18ddbdb143d"
    sha256 cellar: :any,                 ventura:        "2c35cbb28b3e6219414aafb7fe2fd8a3931eeeef1b224e41b49fcff8d9d27ca2"
    sha256 cellar: :any,                 monterey:       "f37b15aab9c88cf7328e0670e7665c8cba49e0594910a21150ffb0291d270a16"
    sha256 cellar: :any,                 big_sur:        "87b7034615ee31987178ac7021b2227fa28f5ef355ba32f16721840c0874de28"
    sha256 cellar: :any,                 catalina:       "eb5fe6b9c98889404e70090f76f02521a54f35ab4602ba2fc2b25b49f421f24a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd5c4196c35299f7a25dd4c3016f6bb6a1735c2f3984afd8f6eb837c8a88f9c3"
  end

  depends_on "cmake" => :build
  depends_on "hdf5"
  depends_on "netcdf"

  def install
    args = std_cmake_args + %w[-DBUILD_TESTING=OFF -DNCXX_ENABLE_TESTS=OFF -DENABLE_TESTS=OFF -DENABLE_NETCDF_4=ON
                               -DENABLE_DOXYGEN=OFF]

    system "cmake", "-S", ".", "-B", "build_shared", *args, "-DBUILD_SHARED_LIBS=ON"
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"

    system "cmake", "-S", ".", "-B", "build_static", *args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "build_static"
    lib.install "build_static/cxx4/libnetcdf-cxx4.a"

    # Remove shim paths
    inreplace [bin/"ncxx4-config", lib/"libnetcdf-cxx.settings"] do |s|
      s.gsub!(Superenv.shims_path/ENV.cc, ENV.cc, false)
      s.gsub!(Superenv.shims_path/ENV.cxx, ENV.cxx, false)
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <netcdf>

      constexpr int nx = 6;
      constexpr int ny = 12;

      int main() {
          int dataOut[nx][ny];
          for (int i = 0; i < nx; i++) {
            for (int j = 0; j < ny; j++) {
              dataOut[i][j] = i * ny + j;
            }
          }
          netCDF::NcFile dataFile("simple_xy.nc", netCDF::NcFile::replace);
          auto xDim = dataFile.addDim("x", nx);
          auto yDim = dataFile.addDim("y", ny);
          auto data = dataFile.addVar("data", netCDF::ncInt, {xDim, yDim});
          data.putVar(dataOut);
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-L#{lib}", "-I#{include}", "-lnetcdf-cxx4", "-o", "test"
    system "./test"
  end
end
