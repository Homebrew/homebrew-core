class NetcdfCxx < Formula
  desc "C++ libraries and utilities for NetCDF"
  homepage "https://www.unidata.ucar.edu/software/netcdf/"
  url "https://github.com/Unidata/netcdf-cxx4/archive/refs/tags/v4.3.1.tar.gz"
  sha256 "e3fe3d2ec06c1c2772555bf1208d220aab5fee186d04bd265219b0bc7a978edc"
  license "NetCDF"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e84953471784443be7fdd3f1f5bc295e2bcdad7b4a926b4e76f6f02ff205484f"
    sha256 cellar: :any,                 arm64_ventura:  "8d967dce894b455bc5647dc9416e5a4eceefbf9a710cce01d80491f5c67a6d1f"
    sha256 cellar: :any,                 arm64_monterey: "055b3191f34e7f1d0c15bd63a50a65fd496a1dd402255d47189908abb8bb6514"
    sha256 cellar: :any,                 arm64_big_sur:  "f95e7cca5e6398b0ac4484cf8b89df1dec5dc2602e57ee7454a80d4d2df9291f"
    sha256 cellar: :any,                 sonoma:         "b36c23e394909bc2d5ec136e8816485b9230d99aa37115e4e3d5c240fb1a568a"
    sha256 cellar: :any,                 ventura:        "4142616c7c72e986bd6ae0159c20e6702db7a8c5044c7540043a6ff57c7fe04b"
    sha256 cellar: :any,                 monterey:       "8e67f665695d5e0131db1fdb2f11030ef8fe462270652c7b1ff05a0e14664bc1"
    sha256 cellar: :any,                 big_sur:        "447ab5ac1c323952c6378b92e52c280f84c7fa7e5bd0c3cbc673b8c9146022b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7db97776cfe5cf54f458816719e1f031b2349004eca65460dc370bfc51cfe627"
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
