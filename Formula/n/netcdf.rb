class Netcdf < Formula
  desc "Libraries and data formats for array-oriented scientific data"
  homepage "https://www.unidata.ucar.edu/software/netcdf/"
  url "https://github.com/Unidata/netcdf-c/archive/refs/tags/v4.9.3.tar.gz"
  sha256 "990f46d49525d6ab5dc4249f8684c6deeaf54de6fec63a187e9fb382cc0ffdff"
  license "BSD-3-Clause"
  head "https://github.com/Unidata/netcdf-c.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:netcdf[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b6556411dffb6a79cade21f4c5935a7732f32b0566fbd95adc9c803578dd7f4c"
    sha256 cellar: :any,                 arm64_sonoma:  "8e5f6edbc1bdc0514eabbb6ba699bfd3a1dac8056d0a18e76eacb4dfdbc747f5"
    sha256 cellar: :any,                 arm64_ventura: "db5219d0b13f8c474852b9786e1c604ec6776a488cfa78446b6cbff87a917827"
    sha256 cellar: :any,                 sonoma:        "8dc2871bf05e90c183d942121bdbeb217b52e84d3c2d76945a747b47664b5206"
    sha256 cellar: :any,                 ventura:       "1521a5bcfc4a455a2b7848c85c4351c7809e31a11d11df4d7739236fe8d80588"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5eca5939b9a6a5b5bd36f1c661e5e7bd950d88fcd5b9b1854d972d4eed1d4983"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c90a09f5e615e4c0bd1140e7e33341eb0dc0bc61934bea412cbb2d54066a191"
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
