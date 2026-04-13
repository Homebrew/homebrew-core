class Hdf5 < Formula
  desc "File format designed to store large amounts of data"
  homepage "https://www.hdfgroup.org/solutions/hdf5/"
  url "https://github.com/HDFGroup/hdf5/releases/download/2.1.1/hdf5-2.1.1.tar.gz"
  sha256 "efff93b5a904d66e8f626d7da60b5eedc9faf544be27dbabbaa87967b8ad798b"
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
    sha256 cellar: :any,                 arm64_tahoe:   "114c9d8e9bea42989f21fb2910f29aa80906bd6924c6d332783d2b38c7a63419"
    sha256 cellar: :any,                 arm64_sequoia: "c6fbf7bfe222ee75a8eec078486f0317e56d7d9c154f22dd135eceda927dfebf"
    sha256 cellar: :any,                 arm64_sonoma:  "b5f41add9cb70b7f5325fef0be693a8433ea60b72b27acf70c68b043f5e2055e"
    sha256 cellar: :any,                 sonoma:        "23e4bf63102a12668a5a1cf07e610a46ced3a917b818fa88592cf721dc7e87e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55e6b9b7905a97cc4bb846368bc88f39f9717c8033cf9c2591d15b5b6e47e0a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8e15df7406f1ae8ef07a41c86c8390a6bf931947becc7de20864206878ad86d"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "libaec"
  depends_on "pkgconf"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "hdf5-mpi", because: "hdf5-mpi is a variant of hdf5, one can only use one or the other"

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
