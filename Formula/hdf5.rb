class Hdf5 < Formula
  desc "File format designed to store large amounts of data"
  homepage "https://www.hdfgroup.org/HDF5"
  url "https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.12/hdf5-1.12.1/src/hdf5-1.12.1.tar.bz2"
  sha256 "aaf9f532b3eda83d3d3adc9f8b40a9b763152218fa45349c3bc77502ca1f8f1c"
  license "BSD-3-Clause"
  revision 1
  version_scheme 1

  # This regex isn't matching filenames within href attributes (as we normally
  # do on HTML pages) because this page uses JavaScript to handle the download
  # buttons and the HTML doesn't contain the related URLs.
  livecheck do
    url "https://www.hdfgroup.org/downloads/hdf5/source-code/"
    regex(/>\s*hdf5[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "823ea99d10515125b68fae9a062e729e16a589235ff47747d8c49db80c0975ac"
    sha256 cellar: :any,                 arm64_big_sur:  "d53d554afab11f19e9de3029fe2b95de35b10195039c76cea28e41da630f62dc"
    sha256 cellar: :any,                 monterey:       "c77af349741708a76fee2be590a10380143c9d4af4f5b28b41fa0f00e404c4f3"
    sha256 cellar: :any,                 big_sur:        "99b02da5cf2447ecf0094331f55ed064070126955d8f8f12af50e28fc49205a0"
    sha256 cellar: :any,                 catalina:       "0d3532971a76448a9d862d6a3796e4e234cd05a1f6b099baa04959f2bdd0af88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c79185e0323616f77cbf2db740a2562391e1944d74d2be95c29022e13dc8e4d0"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gcc" # for gfortran
  depends_on "libaec"

  uses_from_macos "zlib"

  conflicts_with "hdf5-mpi", because: "hdf5-mpi is a variant of hdf5, one can only use one or the other"

  def install
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
