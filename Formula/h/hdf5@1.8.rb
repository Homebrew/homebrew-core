class Hdf5AT18 < Formula
  desc "File format designed to store large amounts of data"
  homepage "https://www.hdfgroup.org/HDF5"
  url "https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.8/hdf5-1.8.23/src/hdf5-1.8.23.tar.bz2"
  sha256 "69ac1f7e28de5a96b45fd597f18b2ce1e1c47f4b2b64dc848a64be66722da64e"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a6a99f30be9d18cb2c44df4bfa05f576ea937f42480c5d4be7dc84db96987f55"
    sha256 cellar: :any,                 arm64_ventura:  "2a610ba27c2230a1bb6503d6c8837856e3d732b01f77e3aa4f424764e256f7f0"
    sha256 cellar: :any,                 arm64_monterey: "cee65157e34fb2bf100ca817d0451140877c4eb2cecb985b6417a88718f17fc0"
    sha256 cellar: :any,                 arm64_big_sur:  "d4b59b70482874bbcb6fa1b7f8ae70380beef2af30b681e9505e761471025199"
    sha256 cellar: :any,                 sonoma:         "2ec8ed104577a536537c695b792d30918db341863dbaf7bcd15333f76f158792"
    sha256 cellar: :any,                 ventura:        "dea8106a00cd493f662522b810e3b621153a1837859eeee0ed89c2000231bb5a"
    sha256 cellar: :any,                 monterey:       "8fee587dbc90c90c2578b238c823246475571548d73bb7dd0526925e7da7e520"
    sha256 cellar: :any,                 big_sur:        "d3d4e0b22028848cede7f5b1f7c89f10726a23b49e3f5bf7f9cf9f5dd162cfa5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e5aad64f5771536c57b07c1edc82a896bdcf61847358ccbee9769e06ea3b0d6"
  end

  keg_only :versioned_formula

  # 1.8.23 is the last release for 1.8.x
  # https://github.com/HDFGroup/hdf5#release-schedule
  disable! date: "2024-02-15", because: :unsupported

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gcc" # for gfortran
  depends_on "libaec"

  def install
    # Work around incompatibility with new linker (FB13194355)
    # https://github.com/HDFGroup/hdf5/issues/3571
    ENV.append "LDFLAGS", "-Wl,-ld_classic" if DevelopmentTools.clang_build_version >= 1500

    inreplace %w[c++/src/h5c++.in fortran/src/h5fc.in bin/h5cc.in],
              "${libdir}/libhdf5.settings",
              "#{pkgshare}/libhdf5.settings"

    inreplace "src/Makefile.am", "settingsdir=$(libdir)", "settingsdir=#{pkgshare}"

    system "autoreconf", "--force", "--install", "--verbose"

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-build-mode=production
      --enable-fortran
      --disable-cxx
      --prefix=#{prefix}
      --with-szlib=#{Formula["libaec"].opt_prefix}
    ]
    args << "--with-zlib=#{Formula["zlib"].opt_prefix}" if OS.linux?

    system "./configure", *args

    # Avoid shims in settings file
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
    system bin/"h5cc", "test.c"
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
    system bin/"h5fc", "test.f90"
    assert_equal version.to_s, shell_output("./a.out").chomp
  end
end
