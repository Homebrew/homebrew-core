class Netcdf < Formula
  desc "Libraries and data formats for array-oriented scientific data"
  homepage "https://www.unidata.ucar.edu/software/netcdf/"
  url "https://github.com/Unidata/netcdf-c/archive/refs/tags/v4.9.2.tar.gz"
  sha256 "bc104d101278c68b303359b3dc4192f81592ae8640f1aee486921138f7f88cb7"
  license "BSD-3-Clause"
  head "https://github.com/Unidata/netcdf-c.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:netcdf[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "090ddac55a52b784b45a323d29b5fed38fa929c9a528879f6bf688a458b9243f"
    sha256 cellar: :any,                 arm64_monterey: "8489eb2c9fc95960b8808f7263ecd33676ab1990e643833aa61b119f47f93d8c"
    sha256 cellar: :any,                 arm64_big_sur:  "30001d4f89d80879128bca7aad40d5f7e1bc9bbd31034a8a0f1589164ea5cf60"
    sha256 cellar: :any,                 ventura:        "adbfce83fb83578e8e65c32db8f2554ef042d97bf78ff3aec044a449f5838084"
    sha256 cellar: :any,                 monterey:       "6b544e3117be98e108d98fecbec3d7ef3bf131702642fa4db7dde741de345a29"
    sha256 cellar: :any,                 big_sur:        "041e42e1e7a4d6ef7b9d7954f0aea1da500f9ba2c8cb2e8ecdca282313a33dc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fe6202c2857ad4d5c0dc9a6c176d85dec2793835f7debb1ba9604fb48dd60ed"
  end

  depends_on "cmake" => :build
  depends_on "hdf5"

  uses_from_macos "m4" => :build
  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

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
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include "netcdf_meta.h"
      int main()
      {
        printf(NC_VERSION);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lnetcdf",
                   "-o", "test"
    if head?
      assert_match(/^\d+(?:\.\d+)+/, `./test`)
    else
      assert_equal version.to_s, `./test`
    end
  end
end
