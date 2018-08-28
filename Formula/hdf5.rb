class Hdf5 < Formula
  desc "File format designed to store large amounts of data"
  homepage "https://www.hdfgroup.org/HDF5"
  url "https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.3/src/hdf5-1.10.3.tar.bz2"
  sha256 "c65cdcce4724a57fd3f8da9f0d109b497be30092acb9fac634d1291190d905a9"

  bottle do
    sha256 "85e9a3bb0e67f75843eefb3d008aa4c9f116efc8de32aa73071cd93270ebca44" => :mojave
    sha256 "42dd926b15a93a466d0b2b376fc20e2dc14d9cdda100f8a7050e6368684f6398" => :high_sierra
    sha256 "18ab613ad07b9b92a6d33118ea595689e833d64f6b4b421bbb2b59a8da6cb304" => :sierra
    sha256 "73437652f5963038481fb143d3f847206a11522ebd326b5af21db939f56fe661" => :el_capitan
  end

  option "with-mpi",                  "Enable parallel support"
  option "with-mpi-cxx-unsupported",  "Enable parallelized C++ API (unsupported)"

  deprecated_option "enable-parallel" => "with-mpi"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gcc" # for gfortran
  depends_on "open-mpi" if build.with?("mpi") \
                        or build.with?("mpi-cxx-unsupported")
  depends_on "szip"

  def install
    inreplace %w[c++/src/h5c++.in fortran/src/h5fc.in tools/src/misc/h5cc.in],
      "${libdir}/libhdf5.settings", "#{pkgshare}/libhdf5.settings"

    inreplace "src/Makefile.am", "settingsdir=$(libdir)", "settingsdir=#{pkgshare}"

    system "autoreconf", "-fiv"

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-szlib=#{Formula["szip"].opt_prefix}
      --enable-build-mode=production
      --enable-fortran
    ]

    if build.without?("mpi") and build.without?("mpi-cxx-unsupported")
      args << "--enable-cxx"
    elsif build.with?("mpi-cxx-unsupported")
      args << "--enable-cxx"
      args << "--enable-parallel"
      args << "--enable-unsupported"
      ENV["CC"] = ENV["CXX"] = ENV["FC"] = "mpi"
       ENV["CC"] += "cc"
      ENV["CXX"] += "cxx"
       ENV["FC"] += "f90"
    end

    if build.with?("mpi")
      args << "--enable-parallel"
      if build.without?("mpi-cxx-unsupported")
        args << "--disable-cxx"
      end
      ENV["CC"] = ENV["CXX"] = ENV["FC"] = "mpi"
       ENV["CC"] += "cc"
      ENV["CXX"] += "cxx"
       ENV["FC"] += "f90"
    end

    system "./configure", *args
    system "make", "install"
  end

  def caveats
    if build.with?("mpi-cxx-unsupported")
      s = <<~EOS
      
      You have built HDF5 with both paralellism and the C++ bindings
      enabled.
      
      This combination of options requires running HDF5’s configure
      script with the “--enable-unsupported” option. Use the build
      products of this library, as rendered with these options, at
      your own risk; the behavior of this permutation of the library
      is explicitly not supported by the publisher.
      
      For more information, q.v. the HDF5 group note sub.:
      https://support.hdfgroup.org/HDF5/hdf5-quest.html#p5thread
      
      EOS
   else
     s = nil
   end
  s
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
