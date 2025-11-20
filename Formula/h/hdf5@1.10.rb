class Hdf5AT110 < Formula
  desc "File format designed to store large amounts of data"
  homepage "https://www.hdfgroup.org/HDF5"
  url "https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.11/src/hdf5-1.10.11.tar.bz2"
  sha256 "0afc77da5c46217709475bbefbca91c0cb6f1ea628ccd8c36196cf6c5a4de304"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "b582f925e723b300ee8401f89307fdc2cb336b7ea691b61f8396890446645ceb"
    sha256 cellar: :any,                 arm64_sonoma:   "b85adcde660662f9ed6f4c9740e1c97a8ec2a1b4be7ff3185142801ce7083a5c"
    sha256 cellar: :any,                 arm64_ventura:  "7c8e8deff03df6d11099246b2ab71ed2decdcdbbc395e4803b0a12fb5d0ec672"
    sha256 cellar: :any,                 arm64_monterey: "06e03e5b27f560906f80721de89c681a56f138f239f04a71142efdb14c180e4c"
    sha256 cellar: :any,                 sonoma:         "83e1a3357f24fe7de568be6fb299907031ed32e888c4dfc56d57f0c213d7772f"
    sha256 cellar: :any,                 ventura:        "f420a1f3da8697f61b51c2006e5e7e5bfad27922dab09fedce4695250b35bcc7"
    sha256 cellar: :any,                 monterey:       "c1c4e6a9a6e42f6e267d44d3a7734ca21eede859a9021156511a99faf0ceacfe"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "a7328ba07bc86946622b3aa178be3c62f48e38c6f75bdb3bd3fdf25b5d2158e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "706516f685fc2d8a3d2c1e6565b36cbc885445f2c0f901a2bd735f3229151590"
  end

  keg_only :versioned_formula

  # 1.10.11 is the last release for 1.10.x
  # https://github.com/HDFGroup/hdf5#release-schedule
  deprecate! date: "2024-07-24", because: :unsupported
  disable! date: "2025-07-24", because: :unsupported

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gcc" # for gfortran
  depends_on "libaec"

  uses_from_macos "zlib"

  def install
    # Work around incompatibility with new linker (FB13194355)
    # https://github.com/HDFGroup/hdf5/issues/3571
    ENV.append "LDFLAGS", "-Wl,-ld_classic" if DevelopmentTools.clang_build_version >= 1500

    inreplace %w[c++/src/h5c++.in fortran/src/h5fc.in bin/h5cc.in],
              "${libdir}/libhdf5.settings",
              "#{pkgshare}/libhdf5.settings"

    inreplace "src/Makefile.am",
              "settingsdir=$(libdir)",
              "settingsdir=#{pkgshare}"

    system "autoreconf", "--force", "--install", "--verbose"

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-build-mode=production
      --enable-fortran
      --enable-cxx
      --prefix=#{prefix}
      --with-szlib=#{Formula["libaec"].opt_prefix}
    ]
    args << "--with-zlib=#{Formula["zlib"].opt_prefix}" if OS.linux?

    system "./configure", *args

    # Avoid shims in settings file
    inreplace "src/libhdf5.settings", Superenv.shims_path/ENV.cxx, ENV.cxx
    inreplace "src/libhdf5.settings", Superenv.shims_path/ENV.cc, ENV.cc

    system "make", "install"
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
    assert_equal version.to_s, shell_output("./a.out").chomp

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
    assert_equal version.to_s, shell_output("./a.out").chomp
  end
end
