class Hdf5AT110 < Formula
  desc "File format designed to store large amounts of data"
  homepage "https://www.hdfgroup.org/HDF5"
  url "https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.8/src/hdf5-1.10.8.tar.bz2"
  sha256 "66ec544b195a4cb9f6ffed034fd82e52429d6112747c2996ab69853f606e546b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "352e9d1e6a79915048862585bf43f37a7aadf7ded5e4491eaad8f53b75bf6175"
    sha256                               arm64_big_sur:  "50f558462450a89684bf94338b6a0fe50579457fb73f16aec14b3a14250ea697"
    sha256 cellar: :any,                 monterey:       "6414fa2d1bc2f02f6811557811b84d2cdcff8edb962e6328d22c352f1bdf1a94"
    sha256 cellar: :any,                 big_sur:        "aaf4050cbc4a4dea9bf6fae1c54ce4f0a93537eaf3b45f5ed9041f6771e04583"
    sha256 cellar: :any,                 catalina:       "d89eb59b029e32ff0689c73245f0dfc3d44a7750a9b84ffbfa05a03ecd24bc2f"
    sha256 cellar: :any,                 mojave:         "386f4217757f910b24d2f5b9f931516c0c96d6bf53b7cfbd581f204b7292a524"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ca37238af9e72dfb071c55b682e3ece97e2fc9f1b45654439ba26be95b2e8c3"
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
