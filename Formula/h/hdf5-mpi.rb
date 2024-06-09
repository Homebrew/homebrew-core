class Hdf5Mpi < Formula
  desc "File format designed to store large amounts of data"
  homepage "https://www.hdfgroup.org/HDF5"
  url "https://github.com/HDFGroup/hdf5/releases/download/hdf5_1.14.4.2/hdf5-1.14.4-2.tar.gz"
  version "1.14.4"
  sha256 "618934b9d45e34f328393e1fde73a8a67e973f8e5a6bae8b609d098a84cb0efe"
  license "BSD-3-Clause"
  version_scheme 1

  livecheck do
    formula "hdf5"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e9691a00ac8e505fbfe276547fac8f40c926659b7ae756a04ecfc0cd86d06ea2"
    sha256 cellar: :any,                 arm64_ventura:  "2c045a01641c589a3f73e7e5b49f90bedb3b4d362818a97016403536d966bd61"
    sha256 cellar: :any,                 arm64_monterey: "edaecb37c499f575aaec2a724faf835dd6ee04299d4f54e735c2c3a528d6e898"
    sha256 cellar: :any,                 sonoma:         "592edf06d0dd539e324787d4b658361e9e73554faea1100a16c595194774748a"
    sha256 cellar: :any,                 ventura:        "dbea915eb8b1494edcca4f0df5bfdcb83d8467c86fb4de555da1779f28e8089a"
    sha256 cellar: :any,                 monterey:       "ae5544130fdd0843e7b281d97a538aa307823f5dee429e681412e35d93ba5cd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d3d1ccbf33cbbe10e13a6969d682217e650eefbaecc0f4a2e62c79394ce06a7"
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
    # Work around incompatibility with new linker (FB13194355)
    # https://github.com/HDFGroup/hdf5/issues/3571
    ENV.append "LDFLAGS", "-Wl,-ld_classic" if DevelopmentTools.clang_build_version >= 1500

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
