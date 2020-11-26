class NetcdfFortran < Formula
  desc "Fortran library for array-oriented scientific data"
  homepage "https://www.unidata.ucar.edu/software/netcdf"
  url "https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-fortran-4.5.2.tar.gz"
  mirror "https://www.gfd-dennou.org/arch/netcdf/unidata-mirror/netcdf-fortran-4.5.2.tar.gz"
  sha256 "b959937d7d9045184e9d2040a915d94a7f4d0185f4a9dceb8f08c94b0c3304aa"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/Unidata/netcdf-fortran.git"

  livecheck do
    url :head
    regex(/^(?:netcdf-|v)?(\d+(?:\.\d+)+)$/i)
  end

  # bottle do
  #   rebuild 1
  #   sha256 "945407cca07cd5096c8f9e00520e5b51fef5d30d6e4bf68775de508268100f4e" => :big_sur
  #   sha256 "bf768c6f17428104b463b55420ed6a57c64870c13f2c475604a3446122a0e6de" => :catalina
  #   sha256 "1ef8f155374e15879156ba393750ef0449f5cea5215f625fcb457176350ea17b" => :mojave
  #   sha256 "1866c199aaa33565c687d83f163a50ad779949d98dd563e967d9b385bdc030f1" => :high_sierra
  # end

  keg_only "to avoid conflict with netcdf-fortran installations of compilers other than gfortran"

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "hdf5"
  depends_on "netcdf"

  uses_from_macos "curl"

  def install
    ENV.deparallelize

    common_args = std_cmake_args << "-DBUILD_TESTING=OFF"
    fortran_args = common_args.dup << "-DNETCDF_INCLUDE_DIR=#{Formula["netcdf"].opt_prefix}/include"
    fortran_args = common_args.dup << "-DNETCDF_C_LIBRARY=#{Formula["netcdf"].opt_prefix}/lib/libnetcdf.dylib"
    fortran_args << "-DENABLE_TESTS=OFF"

    # Fix for netcdf-fortran with GCC 10, remove with next version
    ENV.prepend "FFLAGS", "-fallow-argument-mismatch"

    mkdir "build-fortran" do
      system "cmake", "..", "-DBUILD_SHARED_LIBS=ON", "-DCMAKE_Fortran_COMPILER=gfortran", *fortran_args
      system "make", "install"
      system "make", "clean"
      system "cmake", "..", "-DBUILD_SHARED_LIBS=OFF", *fortran_args
      system "make"
      lib.install "fortran/libnetcdff.a"
    end

    # Remove some shims path
    inreplace [
      bin/"nf-config", lib/"pkgconfig/netcdf-fortran.pc"
    ], HOMEBREW_LIBRARY/"Homebrew/shims/mac/super/clang", "/usr/bin/clang"
  end

  test do
    (testpath/"test.f90").write <<~EOS
      program test
        use netcdf
        integer :: ncid, varid, dimids(2)
        integer :: dat(2,2) = reshape([1, 2, 3, 4], [2, 2])
        call check( nf90_create("test.nc", NF90_CLOBBER, ncid) )
        call check( nf90_def_dim(ncid, "x", 2, dimids(2)) )
        call check( nf90_def_dim(ncid, "y", 2, dimids(1)) )
        call check( nf90_def_var(ncid, "data", NF90_INT, dimids, varid) )
        call check( nf90_enddef(ncid) )
        call check( nf90_put_var(ncid, varid, dat) )
        call check( nf90_close(ncid) )
      contains
        subroutine check(status)
          integer, intent(in) :: status
          if (status /= nf90_noerr) call abort
        end subroutine check
      end program test
    EOS
    system "gfortran", "test.f90", "-L#{lib}", "-I#{include}", "-lnetcdff",
                       "-o", "testf"
    system "./testf"
  end
end
