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
    sha256 cellar: :any,                 arm64_sonoma:   "0a1d427355953eb8813e807e5e4fca3768e406b7f5da08da04aa32da35630250"
    sha256 cellar: :any,                 arm64_ventura:  "cbb92b7e255f0e91be5a329c3dc512841003d4246b4d390850ce24ecd782aab3"
    sha256 cellar: :any,                 arm64_monterey: "785772ae3a29c723c9c574794dd33eff744ce91e22ea212183b299a5083e442c"
    sha256 cellar: :any,                 arm64_big_sur:  "bf70180d4cc7b917c969d6616d946dd4e8c3ba7d657599ae528efa6023ff1858"
    sha256 cellar: :any,                 sonoma:         "41cd2050077bd9f37c7294d19a5d61540cfb0d8d175e232cb60984dc5747f99f"
    sha256 cellar: :any,                 ventura:        "731dc8e39faaa4f0a9a0f04c351361850f6881a51ff90d31bc6f238677ff2e2e"
    sha256 cellar: :any,                 monterey:       "74818d4e93793cfcbc11bc9abbe6dd6db6477f826fa4b588dedebf25dbdde6c5"
    sha256 cellar: :any,                 big_sur:        "17e88d132cb7705347a2a43921893de7ca1c1020734fdf66886f35e2eb751e13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56154fb4f179e5c3fa2db54a2949f3842e629e2aaa293f9e2a20176bc5de7583"
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
