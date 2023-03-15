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
    sha256 cellar: :any,                 arm64_ventura:  "888f98290c2130eb4d4611132f79c8c6aedc441efe475d21db03d13a37def8b5"
    sha256 cellar: :any,                 arm64_monterey: "2d4c728f748fade050e07ead1e2a5f93a794bd4cb1651433e4e8c19f6adafda7"
    sha256 cellar: :any,                 arm64_big_sur:  "c331f3d897c64f40d07f98bef1d4c3074e910e3ba2852b0e1fff69fa8be2e7f4"
    sha256 cellar: :any,                 ventura:        "2195bcb98d223b3e3587b95605fa1356393546f02e77475ee2bd7449e1a38695"
    sha256 cellar: :any,                 monterey:       "30f45b12d30356085e4802aa8bfc9475e0737907347f9a4221836a739088c388"
    sha256 cellar: :any,                 big_sur:        "5002c35ace33664ecda5bbb80c908e83fa4f3b0d01f66b138a91e137e0a2aefa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6d23aef4b3eba60ef187897eb7192235c0ff93c1c983b373588cfea7639c777"
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
