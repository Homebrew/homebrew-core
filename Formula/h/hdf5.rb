class Hdf5 < Formula
  desc "File format designed to store large amounts of data"
  homepage "https://www.hdfgroup.org/HDF5"
  url "https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.14/hdf5-1.14.3/src/hdf5-1.14.3.tar.bz2"
  sha256 "9425f224ed75d1280bb46d6f26923dd938f9040e7eaebf57e66ec7357c08f917"
  license "BSD-3-Clause"
  version_scheme 1

  # This regex isn't matching filenames within href attributes (as we normally
  # do on HTML pages) because this page uses JavaScript to handle the download
  # buttons and the HTML doesn't contain the related URLs.
  livecheck do
    url "https://www.hdfgroup.org/downloads/hdf5/source-code/"
    regex(/>\s*hdf5[._-]v?(\d+(?:\.\d+)+)(?:-\d+)?\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2658a6143881a18a3acbca5cc36167ba4b5ea9b62d5e0a354a1b1e920d2e5c73"
    sha256 cellar: :any,                 arm64_ventura:  "3ba3cb6130a388b6e5b3a1b6c1cb4a32da01b3def5213449fa0551a69f08fcda"
    sha256 cellar: :any,                 arm64_monterey: "7a39fc3c46ecfe1302b50112958d6cce60886cf709650fd1f23600d860ead9d2"
    sha256 cellar: :any,                 sonoma:         "1122c40ec4d438fa9fffbad0342c1537169eac9c053cfadb70c43391e72dd869"
    sha256 cellar: :any,                 ventura:        "7b75e6dc9ebe984a7786a5406098580023554bbe3ce7808280134e8b2f019bb1"
    sha256 cellar: :any,                 monterey:       "1598746b46e5cedbd18baf8cdac110ad44584be0ea95dcab822b70b61ca95c12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45a3ba08b9c14d54fa5afbfe214e8397af81e50e1b3a2b5bf8d97cc5e88b898f"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :test
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

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"

    # Avoid shims in settings file
    inreplace_files = %w[
      build/src/H5build_settings.c
      build/src/libhdf5.settings
    ]

    inreplace inreplace_files, Superenv.shims_path/ENV.cc, ENV.cc

    system "cmake", "--install", "build"
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
