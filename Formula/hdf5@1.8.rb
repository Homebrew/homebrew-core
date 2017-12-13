class Hdf5AT18 < Formula
  desc "File format designed to store large amounts of data"
  homepage "https://www.hdfgroup.org/HDF5"
  url "https://support.hdfgroup.org/ftp/HDF5/current18/src/hdf5-1.8.20.tar.bz2"
  sha256 "a4f2db7e0a078aa324f64e0216a80731731f73025367fa94d158c9b1d3fbdf6f"

  bottle do
    sha256 "71c17931481e2e883e7c8cf8a3b7d3c2b9a13c60692e898bf31bd97c7303421a" => :high_sierra
    sha256 "8ee94808d2943cfb367b85c967f3c0a8623df0215a4d875e760df277b24ca13c" => :sierra
    sha256 "660e3cd1299e526e26e50644e51b3ccf54da002f7d39df1da8ce3e4b2d6d7a95" => :el_capitan
    sha256 "27680e9b0f0301299031c3b78c0a2d35b83c516b37ebf5a5b77c63b37b99b30f" => :yosemite
  end

  keg_only :versioned_formula

  deprecated_option "enable-parallel" => "with-mpi"

  option :cxx11

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "szip"
  depends_on :fortran
  depends_on :mpi => [:optional, :cc, :cxx, :f90]

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
      ENV["CC"] = ENV["MPICC"]
      ENV["CXX"] = ENV["MPICXX"]
      ENV["FC"] = ENV["MPIFC"]

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
