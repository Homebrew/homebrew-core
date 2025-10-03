class NetcdfCxx < Formula
  desc "C++ libraries and utilities for NetCDF"
  homepage "https://www.unidata.ucar.edu/software/netcdf/"
  url "https://github.com/Unidata/netcdf-cxx4/archive/refs/tags/v4.3.1.tar.gz"
  sha256 "e3fe3d2ec06c1c2772555bf1208d220aab5fee186d04bd265219b0bc7a978edc"
  license "NetCDF"
  revision 3

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a193f027eaaa1c1586f10397427d5729fe0d653d569226ea02c85990d00bb449"
    sha256 cellar: :any,                 arm64_sequoia: "50dfd3ba9dea12a4a355e8643a74ca53b6c184c96e3bcdf0e24e3052491be0c8"
    sha256 cellar: :any,                 arm64_sonoma:  "e80f685cdd7fd31e72e0fdeb96a8770a243f4729d0a2f0417808782dfd2d5bc9"
    sha256 cellar: :any,                 arm64_ventura: "f6c50e7a23adf951aae09e8a600f560a4679fb9ce19eabfd692f92442a5a5314"
    sha256 cellar: :any,                 sonoma:        "34da3acc3752fc50b9315b33f90624e2e51eb450af0974d88a3f3895da320d92"
    sha256 cellar: :any,                 ventura:       "7c452e7a0b055cd09f127c86be95fdc41b5f2fdf75f0c00b480a19f79f362ef8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa7a0a059a0a2951e4d07f41a085babd677b0295dd49a02b693e5015ce2a4a29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ab172c8268b7d323e568565c3eddaba2596c6990f9465bdeed7823cbfc81354"
  end

  depends_on "cmake" => :build
  depends_on "hdf5"
  depends_on "netcdf"

  on_macos do
    depends_on "zstd"
  end

  def install
    args = std_cmake_args + %w[
      -DNCXX_ENABLE_TESTS=OFF
      -DENABLE_TESTS=OFF
      -DENABLE_NETCDF_4=ON
      -DENABLE_DOXYGEN=OFF
    ]

    # https://github.com/Unidata/netcdf-cxx4/issues/151#issuecomment-2041111870
    args << "-DHDF5_C_LIBRARY_hdf5=#{Formula["hdf5"].opt_lib}"

    # Workaround to build with CMake 4
    args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"

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
