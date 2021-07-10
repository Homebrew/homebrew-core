class Hdf5Mpi < Formula
  desc "File format designed to store large amounts of data"
  homepage "https://www.hdfgroup.org/HDF5"
  url "https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.12/hdf5-1.12.1/src/hdf5-1.12.1.tar.bz2"
  sha256 "aaf9f532b3eda83d3d3adc9f8b40a9b763152218fa45349c3bc77502ca1f8f1c"
  license "BSD-3-Clause"

  # This regex isn't matching filenames within href attributes (as we normally
  # do on HTML pages) because this page uses JavaScript to handle the download
  # buttons and the HTML doesn't contain the related URLs.
  livecheck do
    url "https://www.hdfgroup.org/downloads/hdf5/source-code/"
    regex(/>\s*hdf5[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256                               arm64_big_sur: "716e3865365c5f8e72579f6b9d0878d3c278518c6132349626ed95f8ddf563c5"
    sha256 cellar: :any,                 big_sur:       "3cec0df153df392877b6ed07b6275c966eadbcb70140100297ead802fe1436c6"
    sha256 cellar: :any,                 catalina:      "485269b3114631acdb6618687e8623f0e771c22a16bbac96f0bf63ccfb05a386"
    sha256 cellar: :any,                 mojave:        "94374cc5ff60100b17c2b5a098806d830eee548e29542132a52171fd9c89fda6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97893f4f8dc202824e830b1a64e27ba333a32bcb138a6192dd5a9b606b9c7678"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gcc" # for gfortran
  depends_on "open-mpi"
  depends_on "szip"

  uses_from_macos "zlib"

  conflicts_with "hdf5", because: "hdf5-mpi is a variant of hdf5, one can only use one or the other"

  def install
    inreplace %w[c++/src/h5c++.in fortran/src/h5fc.in bin/h5cc.in],
      "${libdir}/libhdf5.settings",
      "#{pkgshare}/libhdf5.settings"

    inreplace "src/Makefile.am",
              "settingsdir=$(libdir)",
              "settingsdir=#{pkgshare}"

    on_macos do
      system "autoreconf", "-fiv"
    end

    on_linux do
      system "./autogen.sh"
    end

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-szlib=#{Formula["szip"].opt_prefix}
      --enable-build-mode=production
      --enable-fortran
      --enable-parallel
      CC=mpicc
      CXX=mpic++
      FC=mpifort
      F77=mpif77
      F90=mpif90
    ]

    on_linux do
      args << "--with-zlib=#{Formula["zlib"].opt_prefix}"
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
