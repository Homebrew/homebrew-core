class NetcdfFortran < Formula
  desc "Fortran libraries and utilities for NetCDF"
  homepage "https://www.unidata.ucar.edu/software/netcdf/"
  url "https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v4.6.4.tar.gz"
  sha256 "fc8df99e78cd2aa5ea7b312bce5307b1bea73a118d4860b3b4358971ec376c54"
  license "NetCDF"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5d43404b23bc2cfd071e16c0663c0203312f22ecfa17ee4314ea859a4e5b4895"
    sha256 cellar: :any, arm64_sequoia: "7504b5caa759813adc88e9eb160d66667148ac018c5be906cd129c90f03d8356"
    sha256 cellar: :any, arm64_sonoma:  "d734140af31aecbbdfaba8c798ace1da18169a6029a29570174526ffbf81cc9f"
    sha256 cellar: :any, sonoma:        "eec55d2d27409b52787bf138030251b8feaf6b1318ce35e0b68b8b583747e2af"
    sha256 cellar: :any, arm64_linux:   "6ac40e2f3b7bcb35355b203af4fdd1b39e4c14ee52c8c8834acb86e8c078ccc2"
    sha256 cellar: :any, x86_64_linux:  "5ca271eb57c4a3a238e7fe75fed003bf4873db6ee3a7189a358a32c11ce2cb96"
  end

  depends_on "cmake" => :build
  depends_on "hdf5" => :build
  depends_on "gcc" # for gfortran
  depends_on "netcdf"

  def install
    args = std_cmake_args + %w[-DENABLE_TESTS=OFF -DENABLE_DOXYGEN=OFF]

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
    system "gfortran", "test.f90", "-L#{lib}", "-I#{include}", "-lnetcdff", "-o", "testf"
    system "./testf"
  end
end
