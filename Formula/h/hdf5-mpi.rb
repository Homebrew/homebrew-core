class Hdf5Mpi < Formula
  desc "File format designed to store large amounts of data"
  homepage "https://www.hdfgroup.org/solutions/hdf5/"
  url "https://github.com/HDFGroup/hdf5/releases/download/2.3.0/hdf5-2.3.0.tar.gz"
  sha256 "cd462ef0578927ae75f9e010a806b0dd28f19152db2abf6919cb94f9d5b9b8b0"
  license "BSD-3-Clause"
  version_scheme 1
  compatibility_version 1

  livecheck do
    formula "hdf5"
  end

  bottle do
    manifest_sha256 "f20380efe0c6d34ee4b7d58e22004cb78eb9cfacc866e71d3679d48970fee279"
    sha256 cellar: :any, arm64_golden_gate: "d8286312ff6868766a3eb44b6e4ca5f875f4b2615dadd3c294243192159b4bc8"
    sha256 cellar: :any, arm64_tahoe:       "1a6afc6dad63c3542623cfd1c80bf84d6e822be7f9be2f176bda9f33f40bc5b9"
    sha256 cellar: :any, arm64_sequoia:     "faa59df2afaa78f7bf5b5e55957875cc1fec12a33bde0c9fdf57eb157e79f968"
    sha256 cellar: :any, arm64_linux:       "5a769a53d4c463fddedeb17516f240d48fd6cb32406e7e0799fe8a0c372026c1"
    sha256 cellar: :any, x86_64_linux:      "5efe48612ceda0792b7119254afb197a5c84d68f901eb1efb355ea489815d4ee"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "libaec"
  depends_on "open-mpi"
  depends_on "pkgconf"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "hdf5", because: "hdf5-mpi is a variant of hdf5, one can only use one or the other"

  def install
    # CMake FortranCInterface_VERIFY fails with LTO on Linux due to different GCC and GFortran versions
    ENV.append "FFLAGS", "-fno-lto" if OS.linux?

    args = %w[
      -DCMAKE_C_COMPILER=mpicc
      -DCMAKE_CXX_COMPILER=mpicxx
      -DCMAKE_Fortran_COMPILER=mpif90
      -DHDF5_USE_GNU_DIRS:BOOL=ON
      -DHDF5_INSTALL_CMAKE_DIR=lib/cmake/hdf5
      -DHDF5_ENABLE_PARALLEL:BOOL=ON
      -DHDF5_ALLOW_UNSUPPORTED:BOOL=ON
      -DHDF5_BUILD_FORTRAN:BOOL=ON
      -DHDF5_BUILD_CPP_LIB:BOOL=ON
      -DHDF5_ENABLE_SZIP_SUPPORT:BOOL=ON
      -DHDF5_ENABLE_ZLIB_SUPPORT:BOOL=ON
    ]

    # https://github.com/HDFGroup/hdf5/issues/4310
    args << "-DHDF5_ENABLE_NONSTANDARD_FEATURE_FLOAT16:BOOL=OFF"

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include "hdf5.h"
      int main()
      {
        printf("%d.%d.%d\\n", H5_VERS_MAJOR, H5_VERS_MINOR, H5_VERS_RELEASE);
        return 0;
      }
    C
    system bin/"h5pcc", "test.c"
    assert_equal version.major_minor_patch.to_s, shell_output("./a.out").chomp

    (testpath/"test.f90").write <<~FORTRAN
      use hdf5
      integer(hid_t) :: f, dspace, dset
      integer(hsize_t), dimension(2) :: dims = [2, 2]
      integer :: error = 0, major, minor, rel

      call h5open_f (error)
      if (error /= 0) call abort
      call h5fcreate_f ("test.h5", H5F_ACC_TRUNC_F, f, error)
      if (error /= 0) call abort
      call h5screate_simple_f (2, dims, dspace, error)
      if (error /= 0) call abort
      call h5dcreate_f (f, "data", H5T_NATIVE_INTEGER, dspace, dset, error)
      if (error /= 0) call abort
      call h5dclose_f (dset, error)
      if (error /= 0) call abort
      call h5sclose_f (dspace, error)
      if (error /= 0) call abort
      call h5fclose_f (f, error)
      if (error /= 0) call abort
      call h5close_f (error)
      if (error /= 0) call abort
      CALL h5get_libversion_f (major, minor, rel, error)
      if (error /= 0) call abort
      write (*,"(I0,'.',I0,'.',I0)") major, minor, rel
      end
    FORTRAN
    system bin/"h5pfc", "test.f90"
    assert_equal version.major_minor_patch.to_s, shell_output("./a.out").chomp

    # Make sure that it was built with SZIP/libaec
    config = shell_output("#{bin}/h5cc -showconfig")
    assert_match %r{I/O filters.*LIBAEC}, config
  end
end
