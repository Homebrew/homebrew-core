class Netcdf < Formula
  desc "Libraries and data formats for array-oriented scientific data"
  homepage "https://www.unidata.ucar.edu/software/netcdf/"
  url "https://github.com/Unidata/netcdf-c/archive/refs/tags/v4.10.1.tar.gz"
  sha256 "33c27231c478c3b35da7c7758fbdd02da1fe407abcb16ddfe195f69d164f930d"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/Unidata/netcdf-c.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:netcdf[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "272165524f912aa099b679354b2c9124254b07382ff24a91d4cb7a814b2946df"
    sha256 cellar: :any, arm64_sequoia: "63678e98f8f593e10084bf456d6ff078a23cb3854b37286561c08ef71a30c56a"
    sha256 cellar: :any, arm64_sonoma:  "44cbf680507e42a8075cef9aea20bb7ad67408a51f5a51e9fd08c09b729e0a8a"
    sha256 cellar: :any, sonoma:        "8e34878912d54227043c575f477dcb0eef9fc6065766378b423bdc575600edbf"
    sha256 cellar: :any, arm64_linux:   "13b70976978d8bbcde2532441c2cb4e542589f1799070e0244a2f9d7146b4d0d"
    sha256 cellar: :any, x86_64_linux:  "689b1695b3a3647120d4965fb4d1c85b8e6ab86ad6c26807355a4416901030ac"
  end

  depends_on "cmake" => :build
  depends_on "hdf5"

  uses_from_macos "m4" => :build
  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_macos do
    depends_on "libaec"
    depends_on "zstd"
  end

  def install
    args = %w[-DNETCDF_ENABLE_TESTS=OFF -DNETCDF_ENABLE_HDF5=ON -DNETCDF_ENABLE_DOXYGEN=OFF]
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
  end
end
