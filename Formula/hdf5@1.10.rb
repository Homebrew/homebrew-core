class Hdf5AT110 < Formula
  desc "File format designed to store large amounts of data"
  homepage "https://www.hdfgroup.org/HDF5"
  url "https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.10/src/hdf5-1.10.10.tar.bz2"
  sha256 "56bbf9577aea4f07d7ac400b59f169ab23e5887c306a63dd5cf18b49f521d28c"
  license "BSD-3-Clause"

  livecheck do
    url "https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/"
    regex(%r{href=["']?hdf5[._-]v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1c31665b4e29c000cb2a7a8d51c419eedf0bebd58b0d82fe3201931d50b4c9b9"
    sha256 cellar: :any,                 arm64_monterey: "16fd8ed8e1ecea75ca0e008dc26b440d89f2e2c613a884adbb1d9f5045586bc1"
    sha256 cellar: :any,                 arm64_big_sur:  "d5f2614162252b0ace675a83ad5616e6df6e114b02360fd30a148e74fa70c33a"
    sha256 cellar: :any,                 ventura:        "e991fd4c2b5e6ab7ad64a88a5b6607dd67b26fb7de559bda0c05c6a65dc367c2"
    sha256 cellar: :any,                 monterey:       "bdb7eefe3aebfb8f7a52eee200edba78a75c74653426924904a60c082a8e38da"
    sha256 cellar: :any,                 big_sur:        "d2530f8e2d5fa6208be6c5d6d2447c7494a83aac17df571dbf94f8bafe7a6799"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c54a44fcdc0056728bc16d0b10e871547ff304fba1be123238fc8e9203930adb"
  end

  keg_only :versioned_formula

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gcc" # for gfortran
  depends_on "libaec"

  uses_from_macos "zlib"

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
