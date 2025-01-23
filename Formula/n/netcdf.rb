class Netcdf < Formula
  desc "Libraries and data formats for array-oriented scientific data"
  homepage "https://www.unidata.ucar.edu/software/netcdf/"
  url "https://github.com/Unidata/netcdf-c/archive/refs/tags/v4.9.2.tar.gz"
  sha256 "bc104d101278c68b303359b3dc4192f81592ae8640f1aee486921138f7f88cb7"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/Unidata/netcdf-c.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:netcdf[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "70dfa63c3d6c0bc99c87e3396640dab20168be0922c86220b37249f12aca32b5"
    sha256 cellar: :any,                 arm64_sonoma:  "1de9848cbbca463fb680cd0d9046eb0074c4fc5a576c6ec170226b7e8003e29c"
    sha256 cellar: :any,                 arm64_ventura: "de58c0589a531564788da724ea83373d9a7d6e5eb85eb59106fc8141be027edc"
    sha256 cellar: :any,                 sonoma:        "3c20b4751784056cefd18fc1c3d6d8c5f000a2f3cfdd0ae17889d2d3f7f7fb04"
    sha256 cellar: :any,                 ventura:       "55bfa492d1653d4b73ef9cb288d4133e00ec101427d406461f20d379dadc7d12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d08319d7d9cc73b8dbdea396221f5c499a3db2f50933640af1407e2140875a22"
  end

  depends_on "cmake" => :build
  depends_on "hdf5"

  uses_from_macos "m4" => :build
  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_macos do
    depends_on "zstd"
  end

  def install
    args = %w[-DENABLE_TESTS=OFF -DENABLE_NETCDF_4=ON -DENABLE_DOXYGEN=OFF]
    # Fixes "relocation R_X86_64_PC32 against symbol `stderr@@GLIBC_2.2.5' can not be used" on Linux
    args << "-DCMAKE_POSITION_INDEPENDENT_CODE=ON" if OS.linux?

    system "cmake", "-S", ".", "-B", "build_shared", *args, "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"
    system "cmake", "-S", ".", "-B", "build_static", *args, "-DBUILD_SHARED_LIBS=OFF", *std_cmake_args
    system "cmake", "--build", "build_static"
    lib.install "build_static/liblib/libnetcdf.a"

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
