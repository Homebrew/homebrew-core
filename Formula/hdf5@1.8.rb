class Hdf5AT18 < Formula
  desc "File format designed to store large amounts of data"
  homepage "https://www.hdfgroup.org/HDF5"
  # NOTE: 1.8.23 is expected to be the last release for HDF5-1.8
  # (see: https://portal.hdfgroup.org/display/support/HDF5%201.8.22#HDF51.8.22-futureFutureofHDF5-1.8).
  url "https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.8/hdf5-1.8.22/src/hdf5-1.8.22.tar.bz2"
  sha256 "689b88c6a5577b05d603541ce900545779c96d62b6f83d3f23f46559b48893a4"
  revision 4

  livecheck do
    url "https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.8/"
    regex(%r{href=["']?hdf5[._-]v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "21575ec969a79e88eef424a823ebb9f7fe85c96f982faf46a5043f4ad55defb9"
    sha256 cellar: :any,                 arm64_big_sur:  "a67e86e9a05c5a5d39137d11a4621162181815c20e9c27c7f48c7f129be65db2"
    sha256 cellar: :any,                 monterey:       "8d88ab9a75698dff01d2e2de7a0eb130c2e82a576661b693dc4396c59e7c63a6"
    sha256 cellar: :any,                 big_sur:        "4b788d8b77a6f2cd98c6d32e6952142a31dd1c092a5a369133bd905b0483cd05"
    sha256 cellar: :any,                 catalina:       "d4e81cfc7df31d2395daba3432682484cd90a5cefe20778ecfefccddda52d2ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e1d82d3c1b0acce553621ac430d55722faf3fa72665beb43c6381966d5fa814"
  end

  keg_only :versioned_formula

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gcc" # for gfortran
  depends_on "libaec"

  def install
    inreplace %w[c++/src/h5c++.in fortran/src/h5fc.in bin/h5cc.in],
              "${libdir}/libhdf5.settings",
              "#{pkgshare}/libhdf5.settings"

    inreplace "src/Makefile.am", "settingsdir=$(libdir)", "settingsdir=#{pkgshare}"

    system "autoreconf", "--force", "--install", "--verbose"

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-build-mode=production
      --enable-fortran
      --disable-cxx
      --prefix=#{prefix}
      --with-szlib=#{Formula["libaec"].opt_prefix}
    ]
    args << "--with-zlib=#{Formula["zlib"].opt_prefix}" if OS.linux?

    system "./configure", *args

    # Avoid shims in settings file
    inreplace "src/libhdf5.settings", Superenv.shims_path/ENV.cc, ENV.cc

    system "make", "install"
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
    system "#{bin}/h5cc", "test.c"
    assert_equal version.to_s, shell_output("./a.out").chomp

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
    system "#{bin}/h5fc", "test.f90"
    assert_equal version.to_s, shell_output("./a.out").chomp
  end
end
