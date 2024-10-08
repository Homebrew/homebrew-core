class Hdf5 < Formula
  desc "File format designed to store large amounts of data"
  homepage "https://www.hdfgroup.org/solutions/hdf5/"
  url "https://github.com/HDFGroup/hdf5/releases/download/hdf5_1.14.4.3/hdf5-1.14.4-3.tar.gz"
  version "1.14.4.3"
  sha256 "019ac451d9e1cf89c0482ba2a06f07a46166caf23f60fea5ef3c37724a318e03"
  license "BSD-3-Clause"
  version_scheme 1

  # Upstream maintains multiple major/minor versions and the "latest" release
  # may be for a lower version, so we have to check multiple releases to
  # identify the highest version.
  livecheck do
    url :url
    strategy :github_releases
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "3854f8260b7212ba4260e7a87a237601130046f13e8b652abc94bf088cabd2ed"
    sha256 cellar: :any,                 arm64_sonoma:  "08e04fb1e3c98a790107802d6cabd95dd2158baafb4cdc44a4ac35e81df1bdb5"
    sha256 cellar: :any,                 arm64_ventura: "c6ffe42943316ae68d90d0de32f7a149a12711c7f45891e9e36d5bad91d63bf5"
    sha256 cellar: :any,                 sonoma:        "45f91f9d68a053b3c062f9ce7b1dac556e110bf26a2e8abb84d5a4274fa929c8"
    sha256 cellar: :any,                 ventura:       "eca34a056cf666df2b93b9026ad1a76ccfc24c24b66f41e8949b02d678d3360c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6fd5b8187cb81abdaf7108ecf539c453438ceb5f2b8f754d0eacee8c33e4fe2"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "libaec"
  depends_on "pkg-config"

  uses_from_macos "zlib"

  conflicts_with "hdf5-mpi", because: "hdf5-mpi is a variant of hdf5, one can only use one or the other"

  # fix c++ regression, can be removed in next release
  patch do
    url "https://github.com/HDFGroup/hdf5/commit/ea76013648aac81cee941a7b7a86f21201d1debf.patch?full_index=1"
    sha256 "c4413888131ddc372e2c6b19230c477f169e63c286efee3ddd6a7fe264eabacd"
  end

  def install
    ENV["libaec_DIR"] = Formula["libaec"].opt_prefix.to_s
    args = %w[
      -DHDF5_USE_GNU_DIRS:BOOL=ON
      -DHDF5_INSTALL_CMAKE_DIR=lib/cmake/hdf5
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
      build/CMakeFiles/h5cc
      build/CMakeFiles/h5hlcc
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
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include "hdf5.h"
      int main()
      {
        printf("%d.%d.%d\\n", H5_VERS_MAJOR, H5_VERS_MINOR, H5_VERS_RELEASE);
        return 0;
      }
    EOS
    system bin/"h5cc", "test.c"
    assert_equal version.major_minor_patch.to_s, shell_output("./a.out").chomp

    (testpath/"test.f90").write <<~EOS
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
    EOS
    system bin/"h5fc", "test.f90"
    assert_equal version.major_minor_patch.to_s, shell_output("./a.out").chomp

    # Make sure that it was built with SZIP/libaec
    config = shell_output("#{bin}/h5cc -showconfig")
    assert_match %r{I/O filters.*DECODE}, config
  end
end
