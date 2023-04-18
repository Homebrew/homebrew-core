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
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "bf95d9b6d60d42e207485b164894d2fbd0a46bfbec3a7fb8a98a682b627d7b2c"
    sha256 cellar: :any,                 arm64_monterey: "eedbdbfa8bc9a676568608959c58b869f54357442e11b4a1a3c2db874886c37e"
    sha256 cellar: :any,                 arm64_big_sur:  "0476498c73b37cb11e5aa210de3e2af561e5107bf25757b38bf9a38a0cd08104"
    sha256 cellar: :any,                 ventura:        "2d340092cdd0005126d5a4b3c38b7a2bb4946de3175ba2fff674f280da775e11"
    sha256 cellar: :any,                 monterey:       "235763dc893a23b56caa69c5c61b0322d31ff57584830c095ffc8b886c27f482"
    sha256 cellar: :any,                 big_sur:        "8c355fe37ff6a3ede90114ccbda7b60f4028a800d5bb0cd75515ecf02cc21800"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6cff00a383bfba4e85fcb40f00e3942a6de4c90b45fa9f51a7e6487dc454e5b"
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
