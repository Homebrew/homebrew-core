class Netcdf < Formula
  desc "Libraries and data formats for array-oriented scientific data"
  homepage "https://www.unidata.ucar.edu/software/netcdf/"
  url "https://github.com/Unidata/netcdf-c/archive/refs/tags/v4.10.0.tar.gz"
  sha256 "ce160f9c1483b32d1ba8b7633d7984510259e4e439c48a218b95a023dc02fd4c"
  license "BSD-3-Clause"
  head "https://github.com/Unidata/netcdf-c.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:netcdf[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c9ddcf980457c6068593640c746b5ed0e7d9b252b251172f6417f8ec2053ea66"
    sha256 cellar: :any,                 arm64_sequoia: "163fed6be2e0d4aa70b327be4ca3cc702562764d8138ec2fa5a64c6da5c62e96"
    sha256 cellar: :any,                 arm64_sonoma:  "951763c3895c6634ed1de5f58a33f5b6df4f42b13fb7863d39eddcd3d88e2c70"
    sha256 cellar: :any,                 sonoma:        "cdb43a113fbd0ffeb4451c3152c8c1c07fcbabbc90cc8575edf4681ebf0093b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "451da8be1f36b126818e0f0ddb8bde360fd49c7b2af26ed7b920915d4e4caab8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33334198a494db895097576ac2a797497979a47617ae8cd19c13abe2d8052c41"
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
