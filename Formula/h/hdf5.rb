class Hdf5 < Formula
  desc "File format designed to store large amounts of data"
  homepage "https://www.hdfgroup.org/solutions/hdf5/"
  url "https://github.com/HDFGroup/hdf5/releases/download/2.1.0/hdf5-2.1.0.tar.gz"
  sha256 "ce7f5515a95d588b8606c3fb50643f8b88ac52ffbbde9c63bb1edca6a256e964"
  license "BSD-3-Clause"
  version_scheme 1
  compatibility_version 1

  # Upstream maintains multiple major/minor versions and the "latest" release
  # may be for a lower version, so we have to check multiple releases to
  # identify the highest version.
  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a89a509b94c8b2e887487385f4ffeeada668f32425cc2e1d1bb9dc7ff096d0b7"
    sha256 cellar: :any,                 arm64_sequoia: "b823ba122b94c5e8289484ca813b9b4064cd4bd68d169760beb56a635ef6d79d"
    sha256 cellar: :any,                 arm64_sonoma:  "e35959d536851682901c6a93f656f3013c8ca810ca6f0259beedb5e460b5fa40"
    sha256 cellar: :any,                 sonoma:        "042a0a7a4ab8cb9243c6e46b9d9bd60808ece223d234faec6877240d9a291afa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "102940d158d9e0849ff741ed3cb5a343a88f79c69d353be69939365cfba1e6ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23345011ea93198b940537286a29111c51f4ba78788278a7af84651cebdfaec3"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "libaec"
  depends_on "pkgconf"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "hdf5-mpi", because: "hdf5-mpi is a variant of hdf5, one can only use one or the other"

  # Fix malformed HL Fortran dylib version flags from a soversion interface typo.
  # Upstream PR ref: https://github.com/HDFGroup/hdf5/pull/6267
  patch do
    url "https://github.com/HDFGroup/hdf5/commit/bf2c70a3d2a428be67a2273e0acdc97c622c0aab.patch?full_index=1"
    sha256 "ad83d07a9f3de540619f55ab12b8997b463cdb804eb07cac790f556ca55b4517"
  end

  def install
    # Avoid c/c++ shims in settings files
    inreplace_c_files = %w[
      src/H5build_settings.cmake.c.in
      src/libhdf5.settings.in
    ]
    inreplace inreplace_c_files do |s|
      s.gsub! "@CMAKE_C_COMPILER@", ENV.cc
      s.gsub! "@CMAKE_CXX_COMPILER@", ENV.cxx
    end

    # CMake FortranCInterface_VERIFY fails with LTO on Linux due to different GCC and GFortran versions
    ENV.append "FFLAGS", "-fno-lto" if OS.linux?

    args = %W[
      -DHDF5_H5CC_C_COMPILER=#{ENV.cc}
      -DHDF5_H5CC_CXX_COMPILER=#{ENV.cxx}
      -DHDF5_USE_GNU_DIRS:BOOL=ON
      -DHDF5_INSTALL_CMAKE_DIR=lib/cmake/hdf5
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
    system bin/"h5cc", "test.c"
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
    system bin/"h5fc", "test.f90"
    assert_equal version.major_minor_patch.to_s, shell_output("./a.out").chomp

    # Make sure that it was built with SZIP/libaec
    config = shell_output("#{bin}/h5cc -showconfig")
    assert_match %r{I/O filters.*DECODE}, config
  end
end
