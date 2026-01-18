class NetcdfFortran < Formula
  desc "Fortran libraries and utilities for NetCDF"
  homepage "https://www.unidata.ucar.edu/software/netcdf/"
  url "https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v4.6.2.tar.gz"
  sha256 "44cc7b5626b0b054a8503b8fe7c1b0ac4e0a79a69dad792c212454906a9224ca"
  license "NetCDF"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7201bd78c6bdf89900c295717ec925c1a29e98d86c568efe09fab3cab906ad96"
    sha256 cellar: :any,                 arm64_sequoia: "d91c6c35e16156f4542f17de1103e15b8471aa0fca99e94bb3762e9644e383e6"
    sha256 cellar: :any,                 arm64_sonoma:  "5473275962edf3112c6075204d6cdf55dbd90e5677fb96d23a191683620fbf77"
    sha256 cellar: :any,                 arm64_ventura: "46de0b263944a9043587d3786893444f54dbb156f7ee8d9e8db7bce515c6079b"
    sha256 cellar: :any,                 sonoma:        "e6fd6c9ef98bd9a1598007909f3ce4b2d0d7fc0c36157146924197ab722d7426"
    sha256 cellar: :any,                 ventura:       "9e56a4edce4c857dbe748e52bbef8252c7bf7fab0521159aef743a8591eb96f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e64fc9a9d7cdeecd02e16f6d5ecf60e6244f99ce9cdda0e49f17e4028c9f8cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c43bc1f9b6084692f9dec942860261facb88aa2fff0d5c9989843d8297e6dbdd"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "hdf5"
  depends_on "netcdf"

  def install
    args = std_cmake_args + %w[-DENABLE_TESTS=OFF -DENABLE_DOXYGEN=OFF]

    # Help netcdf-fortran find netcf
    # https://github.com/Unidata/netcdf-fortran/issues/301#issuecomment-1183204019
    args << "-DnetCDF_LIBRARIES=#{Formula["netcdf"].opt_lib}/#{shared_library("libnetcdf")}"
    args << "-DnetCDF_INCLUDE_DIR=#{Formula["netcdf"].opt_include}"

    system "cmake", "-S", ".", "-B", "build_shared", *args, "-DBUILD_SHARED_LIBS=ON"
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"

    system "cmake", "-S", ".", "-B", "build_static", *args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "build_static"
    lib.install "build_static/fortran/libnetcdff.a"

    # Remove shim paths
    inreplace [bin/"nf-config", lib/"pkgconfig/netcdf-fortran.pc"], Superenv.shims_path/ENV.cc, ENV.cc
  end

  test do
    (testpath/"test.f90").write <<~FORTRAN
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
    FORTRAN
    system "gfortran", "test.f90", "-L#{lib}", "-I#{include}", "-lnetcdff",
                       "-o", "testf"
    system "./testf"
  end
end
