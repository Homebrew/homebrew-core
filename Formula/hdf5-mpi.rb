class Hdf5Mpi < Formula
  desc "File format designed to store large amounts of data"
  homepage "https://www.hdfgroup.org/HDF5"
  url "https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.12/hdf5-1.12.2/src/hdf5-1.12.2.tar.bz2"
  sha256 "1a88bbe36213a2cea0c8397201a459643e7155c9dc91e062675b3fb07ee38afe"
  license "BSD-3-Clause"
  revision 1
  version_scheme 1

  livecheck do
    formula "hdf5"
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7492722a2de0bac658f71662bdc21d4c75b0cf7bcfa0ef1d2e1080ab2e86ab79"
    sha256 cellar: :any,                 arm64_big_sur:  "8a85b45df3b571bd8e8865406b0cdd1d81f3a695417f84a7882ba5b3afe21579"
    sha256 cellar: :any,                 monterey:       "4300aaa8fef5bef03ec58b3f0e9f9be6fa355636e7c2ea934330f824e51494e7"
    sha256 cellar: :any,                 big_sur:        "7ff6f72a8617a7a1636e8fd44c58aff342a88d4a00a6c072d3a4701670ae79fd"
    sha256 cellar: :any,                 catalina:       "d4ce608c4e4034085c5d5de409cd8d4ad429d6926c4d85680876dcab7c06f0e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be5a8ef9dec6f0c7cec54e0b809b2a5a09f0e2707e2ba2bb62680b42668bf6e5"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gcc" # for gfortran
  depends_on "libaec"
  depends_on "open-mpi"

  uses_from_macos "zlib"

  conflicts_with "hdf5", because: "hdf5-mpi is a variant of hdf5, one can only use one or the other"

  def install
    inreplace %w[c++/src/h5c++.in fortran/src/h5fc.in bin/h5cc.in],
              "${libdir}/libhdf5.settings",
              "#{pkgshare}/libhdf5.settings"

    inreplace "src/Makefile.am",
              "settingsdir=$(libdir)",
              "settingsdir=#{pkgshare}"

    if OS.mac?
      system "autoreconf", "--force", "--install", "--verbose"
    else
      system "./autogen.sh"
    end

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-build-mode=production
      --enable-fortran
      --enable-parallel
      --prefix=#{prefix}
      --with-szlib=#{Formula["libaec"].opt_prefix}
      CC=mpicc
      CXX=mpic++
      FC=mpifort
      F77=mpif77
      F90=mpif90
    ]
    args << "--with-zlib=#{Formula["zlib"].opt_prefix}" if OS.linux?

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
    system "#{bin}/h5pcc", "test.c"
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
    system "#{bin}/h5pfc", "test.f90"
    assert_equal version.to_s, shell_output("./a.out").chomp
  end
end
