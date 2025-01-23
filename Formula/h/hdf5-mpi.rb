class Hdf5Mpi < Formula
  desc "File format designed to store large amounts of data"
  homepage "https://www.hdfgroup.org/solutions/hdf5/"
  url "https://github.com/HDFGroup/hdf5/releases/download/hdf5_1.14.5/hdf5-1.14.5.tar.gz"
  sha256 "ec2e13c52e60f9a01491bb3158cb3778c985697131fc6a342262d32a26e58e44"
  license "BSD-3-Clause"
  version_scheme 1

  livecheck do
    formula "hdf5"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "525c8b1094119b50447660489808d261ddaeff25d7ed93091030e7faf8591397"
    sha256 cellar: :any,                 arm64_sonoma:  "f369f958dc22cb81427b41c8ecb41634c1be06113ea59aee3d6fb741af596bb9"
    sha256 cellar: :any,                 arm64_ventura: "646a22a6d1a2bd71862f88676ff32453fa0e121ebd33aa06fdf4670dd4010ba5"
    sha256 cellar: :any,                 sonoma:        "76add965838179a7a36d86bcbe145405718f240f374c6a7de25de2c5512f5487"
    sha256 cellar: :any,                 ventura:       "896c98d85c77232e9277af1c22d1662c6bf78ed32d58b1647242e641ee06257c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f28cf852f2dbe8552330145e1f8f540c6b824ea2d2e0cad7c9eab9a634712a0"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "libaec"
  depends_on "open-mpi"
  depends_on "pkgconf"

  uses_from_macos "zlib"

  conflicts_with "hdf5", because: "hdf5-mpi is a variant of hdf5, one can only use one or the other"

  # Backport fix for zlib linker flag
  patch do
    url "https://github.com/HDFGroup/hdf5/commit/e64e1ea881c431a9561b83607d722994af641026.patch?full_index=1"
    sha256 "2803c3269f3085df38500b9992c4a107f422a5df8a7afa6158607b93c00d9179"
  end

  # Apply open PR to fix upstream breakage to `libaec` detection and pkg-config flags
  # PR ref: https://github.com/HDFGroup/hdf5/pull/5010
  # Issue ref: https://github.com/HDFGroup/hdf5/issues/4949
  patch do
    url "https://github.com/HDFGroup/hdf5/commit/8089a2dd5c3da636ab1c263e1ec7ae2e9bc845f7.patch?full_index=1"
    sha256 "cb94cc2a898b3df26b99a874129b93555b1cc64387af73d121735784eaf63888"
  end

  def install
    args = %w[
      -DHDF5_USE_GNU_DIRS:BOOL=ON
      -DHDF5_INSTALL_CMAKE_DIR=lib/cmake/hdf5
      -DHDF5_ENABLE_PARALLEL:BOOL=ON
      -DALLOW_UNSUPPORTED:BOOL=ON
      -DHDF5_BUILD_FORTRAN:BOOL=ON
      -DHDF5_BUILD_CPP_LIB:BOOL=ON
      -DHDF5_ENABLE_SZIP_SUPPORT:BOOL=ON
    ]

    # https://github.com/HDFGroup/hdf5/issues/4310
    args << "-DHDF5_ENABLE_NONSTANDARD_FEATURE_FLOAT16:BOOL=OFF"

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args

    # Avoid c shims in settings files
    inreplace_c_files = %w[
      build/src/H5build_settings.c
      build/src/libhdf5.settings
    ]
    inreplace inreplace_c_files, Superenv.shims_path/ENV.cc, ENV.cc

    # Avoid cpp shims in settings files
    inreplace_cxx_files = %w[
      build/CMakeFiles/h5c++
      build/CMakeFiles/h5hlc++
    ]
    inreplace_cxx_files << "build/src/libhdf5.settings" if OS.linux?
    inreplace inreplace_cxx_files, Superenv.shims_path/ENV.cxx, ENV.cxx

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
