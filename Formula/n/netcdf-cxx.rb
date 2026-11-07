class NetcdfCxx < Formula
  desc "C++ libraries and utilities for NetCDF"
  homepage "https://www.unidata.ucar.edu/software/netcdf/"
  url "https://github.com/Unidata/netcdf-cxx4/archive/refs/tags/v4.3.2.tar.gz"
  sha256 "f7afc1a69b5d82b3892a2d4cf2823767657a5e51a8c1170bf14b0fc6648cf2b8"
  license "NetCDF"
  compatibility_version 2

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f44f7a735f164facbde33e928bb7173359b57057e95ab1625a62ca905757b528"
    sha256 cellar: :any, arm64_tahoe:       "99c1c86b1ab186f4ba17658f17c1df632cad1a7034aec69dc4b2a6935115d6b7"
    sha256 cellar: :any, arm64_sequoia:     "de135267806b271052aa12181c0ef8f97f9ceb70bc0db0f54817d5e42cf20bd0"
    sha256 cellar: :any, arm64_linux:       "ed943d2516eab976c2e550a1cdd527514b72499e2057e44a83beb81ebdf87cdf"
    sha256 cellar: :any, x86_64_linux:      "452234c7d474faac41d20ef2daa57f054bf96bcb47dddefdeb585b8368e70099"
  end

  depends_on "cmake" => :build
  depends_on "hdf5"
  depends_on "netcdf"

  on_macos do
    depends_on "zstd"
  end

  deny_network_access!

  def install
    args = std_cmake_args + %w[
      -DNCXX_ENABLE_TESTS=OFF
      -DENABLE_TESTS=OFF
      -DENABLE_NETCDF_4=ON
      -DENABLE_DOXYGEN=OFF
    ]

    # HDF5's CMake config does not set this variable, which is needed to link the filter plugins
    args << "-DHDF5_C_LIBRARY_hdf5=#{formula_opt_lib("hdf5")}/#{shared_library("libhdf5")}"

    system "cmake", "-S", ".", "-B", "build_shared", *args, "-DBUILD_SHARED_LIBS=ON"
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"

    system "cmake", "-S", ".", "-B", "build_static", *args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "build_static"
    lib.install "build_static/cxx4/libnetcdf-cxx4.a"

    # Remove shim paths
    inreplace [bin/"ncxx4-config", lib/"libnetcdf-cxx.settings"] do |s|
      s.gsub!(Superenv.shims_path/ENV.cc, ENV.cc, audit_result: false)
      s.gsub!(Superenv.shims_path/ENV.cxx, ENV.cxx, audit_result: false)
    end
  end

  test do
    (testpath/"test.cpp").write <<~CPP
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
    CPP
    system ENV.cxx, "test.cpp", "-std=c++11", "-L#{lib}", "-I#{include}", "-lnetcdf-cxx4", "-o", "test"
    system "./test"
  end
end
