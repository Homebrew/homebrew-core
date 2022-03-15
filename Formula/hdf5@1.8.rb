class Hdf5AT18 < Formula
  desc "File format designed to store large amounts of data"
  homepage "https://www.hdfgroup.org/HDF5"
  # NOTE: 1.8.23 is expected to be the last release for HDF5-1.8
  # (see: https://portal.hdfgroup.org/display/support/HDF5%201.8.22#HDF51.8.22-futureFutureofHDF5-1.8).
  url "https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.8/hdf5-1.8.22/src/hdf5-1.8.22.tar.bz2"
  sha256 "689b88c6a5577b05d603541ce900545779c96d62b6f83d3f23f46559b48893a4"
  revision 3

  livecheck do
    url "https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.8/"
    regex(%r{href=["']?hdf5[._-]v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "993e6daccf524d67fb067decd0258e2d7d7f30d67d4e003b3b0638eb79c32724"
    sha256 cellar: :any,                 arm64_big_sur:  "802b34502415968c0a1322f55e68086c7122dbdd96026e26e21cdfe50bbef136"
    sha256 cellar: :any,                 monterey:       "ef062baf9ecd358277129436555492b291eb15b50f92abda3f9e1f793622e910"
    sha256 cellar: :any,                 big_sur:        "25f4af91d8f934b8d706271bb31d27a6b1f42e9fa4c6186687cea9078c0e56a0"
    sha256 cellar: :any,                 catalina:       "65d03686011e2cd7c575c56829b9b639a0b04e1a94fb827f97e4897de2a9126c"
    sha256 cellar: :any,                 mojave:         "b2af62b2ad8128b5df29097a95d32555b072aaf10f39ab2d0f3b36ca5c8b5d56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bea37af6734b50fdc36587b6bddea53c7aa24b6bcdcf17b303366b35870e46be"
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
