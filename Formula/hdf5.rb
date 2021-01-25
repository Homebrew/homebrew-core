class Hdf5 < Formula
  desc "File format designed to store large amounts of data"
  homepage "https://www.hdfgroup.org/HDF5"
  url "https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.12/hdf5-1.12.0/src/hdf5-1.12.0.tar.bz2"
  sha256 "97906268640a6e9ce0cde703d5a71c9ac3092eded729591279bf2e3ca9765f61"
  revision 1

  livecheck do
    url "https://www.hdfgroup.org/downloads/hdf5/"
    regex(/Newsletter for HDF5[._-]v?(.*?) Release/i)
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "7cd7cdc13241744c74a94eb578575c357cf263ff0228251a7882a9b7452bac92" => :big_sur
    sha256 "2eb3e73920211c3b9f2b8fb3e2bd39d00dfd5069812e3639bb39d4cfe7d78cab" => :arm64_big_sur
    sha256 "ff70299b918490134fb3e883110f0092d591885db3fc798f2cc0f48cd9472f36" => :catalina
    sha256 "450afa0c0e0783b416e67df0d2a56c5f12518df65ba0326884e06f3388c5c445" => :mojave
    sha256 "541d0b241a81248d8b6c3d3b205fb3f319e5cefe751d7750aa2749b9696ff749" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gcc" # for gfortran
  depends_on "szip"

  uses_from_macos "zlib"

  def install
    inreplace %w[c++/src/h5c++.in fortran/src/h5fc.in bin/h5cc.in],
      "${libdir}/libhdf5.settings",
      "#{pkgshare}/libhdf5.settings"

    inreplace "src/Makefile.am",
              "settingsdir=$(libdir)",
              "settingsdir=#{pkgshare}"

    system "autoreconf", "-fiv"

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-szlib=#{Formula["szip"].opt_prefix}
      --enable-build-mode=production
      --enable-fortran
      --enable-cxx
    ]
    on_linux do
      args << "--with-zlib=#{Formula["zlib"].opt_prefix}"
    end

    system "./configure", *args

    # Avoid shims in settings file
    inreplace "src/libhdf5.settings", HOMEBREW_LIBRARY/"Homebrew/shims/mac/super/clang", "/usr/bin/clang"

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
