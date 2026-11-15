class Netcdf < Formula
  desc "Libraries and data formats for array-oriented scientific data"
  homepage "https://www.unidata.ucar.edu/software/netcdf/"
  url "https://github.com/Unidata/netcdf-c/archive/refs/tags/v4.10.1.tar.gz"
  sha256 "33c27231c478c3b35da7c7758fbdd02da1fe407abcb16ddfe195f69d164f930d"
  license "BSD-3-Clause"
  revision 1
  compatibility_version 1
  head "https://github.com/Unidata/netcdf-c.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:netcdf[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "e4b6a880a8a9a4e354db231c7f7bb029cc8318cd504b5dda98110bd2c089c498"
    sha256 arm64_tahoe:       "61dd571420bf730f8bc3f24b162ba5450e1aa1eaa522aa592038bd8622ff4c10"
    sha256 arm64_sequoia:     "b0720ba605f4915d5fa1edb1a2288f276bd07749f97d4921988f2ac71e244011"
    sha256 arm64_sonoma:      "5d65a07376386afafeb9b8c656bce0cca0d425848e7b647394a2787a468ad8ac"
    sha256 arm64_linux:       "d982ff6c2ed8c063cd44e14c7893f15c5c7f98fd80f39a436f40d2c3cdc963f4"
    sha256 x86_64_linux:      "ea61f420e72dcb4498adf6e647a49d8a3f36255076c925d3a0d0e7f53ea47a53"
  end

  depends_on "cmake" => :build
  depends_on "hdf5"
  depends_on "libaec"
  depends_on "zstd"

  uses_from_macos "m4" => :build
  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = %w[-DNETCDF_ENABLE_TESTS=OFF -DNETCDF_ENABLE_HDF5=ON -DNETCDF_ENABLE_DOXYGEN=OFF
              -DNETCDF_PLUGIN_INSTALL=ON]
    # Fixes "relocation R_X86_64_PC32 against symbol `stderr@@GLIBC_2.2.5' can not be used" on Linux
    args << "-DCMAKE_POSITION_INDEPENDENT_CODE=ON" if OS.linux?

    system "cmake", "-S", ".", "-B", "build_shared", *args, "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"
    system "cmake", "-S", ".", "-B", "build_static", *args, "-DBUILD_SHARED_LIBS=OFF", *std_cmake_args
    system "cmake", "--build", "build_static"
    lib.install "build_static/libnetcdf.a"

    # Remove shim paths
    inreplace [bin/"nc-config", lib/"pkgconfig/netcdf.pc", lib/"cmake/netCDF/netCDFConfig.cmake",
               lib/"libnetcdf.settings"], Superenv.shims_path/ENV.cc, ENV.cc
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include "netcdf_meta.h"
      int main()
      {
        printf(NC_VERSION);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lnetcdf",
                   "-o", "test"
    assert_equal version.to_s, `./test`

    # check to see if HDF5 filter plugins are present in bottle
    %w[h5deflate h5fletcher32 h5shuffle h5zstd zhdf5filters zstdfilters].each do |filter|
      assert_path_exists prefix/"hdf5/lib/plugin"/shared_library("lib__nc#{filter}")
    end
  end
end
