class Netcdf < Formula
  desc "Libraries and data formats for array-oriented scientific data"
  homepage "https://www.unidata.ucar.edu/software/netcdf/"
  url "https://github.com/Unidata/netcdf-c/archive/refs/tags/v4.9.3.tar.gz"
  sha256 "990f46d49525d6ab5dc4249f8684c6deeaf54de6fec63a187e9fb382cc0ffdff"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/Unidata/netcdf-c.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:netcdf[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f14f6311dc30ae573a8d91eb5ec97130592a7b1d2af4603d978b20edd8c7d8bf"
    sha256 cellar: :any,                 arm64_sequoia: "4b6f34e68991fa000dc7e2bddbbae277dc1296a3ca82c3f5224881bf366d6b90"
    sha256 cellar: :any,                 arm64_sonoma:  "9c2ab132fbf10ae39e32f18b061ecd198c8d56bf7d9871d030b4a05cdcd38c91"
    sha256 cellar: :any,                 sonoma:        "bc6addc3d076172b764b2e8e2b071d5b686c4319864ab8c4c9aca35318a2658f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8fff8f6a39aa352bea00445dc38d5ca17daf43f3721910e577d34cb6a3031eaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01ce3ff1026ce15003b24232edc7e334a12b5eab6252fee87c3fe933b84a4ee2"
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
    args = %w[-DNETCDF_ENABLE_TESTS=OFF -DNETCDF_ENABLE_NETCDF_4=ON -DNETCDF_ENABLE_DOXYGEN=OFF]
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
