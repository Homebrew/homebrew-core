class Hdf5Mpi < Formula
  desc "File format designed to store large amounts of data"
  homepage "https://www.hdfgroup.org/solutions/hdf5/"
  url "https://github.com/HDFGroup/hdf5/releases/download/2.1.0/hdf5-2.1.0.tar.gz"
  sha256 "ce7f5515a95d588b8606c3fb50643f8b88ac52ffbbde9c63bb1edca6a256e964"
  license "BSD-3-Clause"
  version_scheme 1
  compatibility_version 1

  livecheck do
    formula "hdf5"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "36140cb8bb4db4a6a05656eabc3a216cc97085952ba8310e1eaf42519c60409e"
    sha256 cellar: :any,                 arm64_sequoia: "0349531e9e56d74f9e11b18ba075a3023bb4890ed8626854da393261ded6d621"
    sha256 cellar: :any,                 arm64_sonoma:  "bdd44591f56fcbe61047ab61a22d0656c12290741e9228c0508a951f36eb9e16"
    sha256 cellar: :any,                 sonoma:        "fae2af5337df5f36a9b88f21060bc01384f5905612f9c36303179d46e04b6edc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75663ef3635622dc2882b99012535edcdf0a684d6a15cbd503edd2f4ae48dba5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5581f10dfc0966ac5a6c386140debb38f3642cc982ab0c36647e34ab2f408abd"
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

  # Fix malformed HL Fortran dylib version flags from a soversion interface typo.
  # Upstream PR ref: https://github.com/HDFGroup/hdf5/pull/6267
  patch do
    url "https://github.com/HDFGroup/hdf5/commit/bf2c70a3d2a428be67a2273e0acdc97c622c0aab.patch?full_index=1"
    sha256 "ad83d07a9f3de540619f55ab12b8997b463cdb804eb07cac790f556ca55b4517"
  end

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
    assert_match %r{I/O filters.*DECODE}, config
  end
end
