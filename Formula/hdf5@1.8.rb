class Hdf5AT18 < Formula
  desc "File format designed to store large amounts of data"
  homepage "https://www.hdfgroup.org/HDF5"
  url "https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.8/hdf5-1.8.21/src/hdf5-1.8.21.tar.bz2"
  sha256 "e5b1b1dee44a64b795a91c3321ab7196d9e0871fe50d42969761794e3899f40d"

  bottle do
    sha256 "100e63ca57e49713edef20a610add098d9da6cf75f2e12146eb17a2625a6b6a3" => :mojave
    sha256 "9df9c3319bf0734c9bed37057db565b11df30db01f380ce069d78bb54a9e01a2" => :high_sierra
    sha256 "5dfcc37589233e529bf0094bcc376743ca6dee2c40bd7dc87c8d4d5cb6d68a6e" => :sierra
  end

  keg_only :versioned_formula

  option "with-mpi", "Enable parallel support"
  option :cxx11

  deprecated_option "enable-parallel" => "with-mpi"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gcc" # for gfortran
  depends_on "open-mpi" if build.with? "mpi"
  depends_on "szip"

  def install
    ENV.cxx11 if build.cxx11?

    inreplace %w[c++/src/h5c++.in fortran/src/h5fc.in tools/misc/h5cc.in],
      "${libdir}/libhdf5.settings", "#{pkgshare}/libhdf5.settings"

    inreplace "src/Makefile.am", "settingsdir=$(libdir)", "settingsdir=#{pkgshare}"

    system "autoreconf", "-fiv"

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-szlib=#{Formula["szip"].opt_prefix}
      --enable-build-mode=production
      --enable-fortran
    ]

    if build.without?("mpi")
      args << "--enable-cxx"
    else
      args << "--disable-cxx"
    end

    if build.with? "mpi"
      ENV["CC"] = "mpicc"
      ENV["CXX"] = "mpicxx"
      ENV["FC"] = "mpif90"

      args << "--enable-parallel"
    end

    system "./configure", *args
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
