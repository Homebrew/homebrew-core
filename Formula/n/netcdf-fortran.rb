class NetcdfFortran < Formula
  desc "Fortran libraries and utilities for NetCDF"
  homepage "https://www.unidata.ucar.edu/software/netcdf/"
  url "https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v4.6.1.tar.gz"
  sha256 "40b534e0c81b853081c67ccde095367bd8a5eead2ee883431331674e7aa9509f"
  license "NetCDF"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7698830a4734e8db2ed6fd81b345ec8aa29717d12de539c86046ef0a9fbf039a"
    sha256 cellar: :any,                 arm64_ventura:  "f69dec2020417b0e8199b02be5a47c4ca2da04c7877b71238017cec1eb7d0b14"
    sha256 cellar: :any,                 arm64_monterey: "d37ff2c2dc92218abac1c96650ed04330748e4b2478b8af3a8191f1f09f82ce3"
    sha256 cellar: :any,                 arm64_big_sur:  "656efd1986de89c62f46cc8cee403671e0b27f7a9c5c71462d46dd71bd5b7afc"
    sha256 cellar: :any,                 sonoma:         "873b2d2777ebc868b7b1d42d3cc67490252e7a8734ac88e34403d1ca17324997"
    sha256 cellar: :any,                 ventura:        "9f472b30b1122d65ec0200e712cfbc9fbc568fe5093f7766a54084d63ab01f94"
    sha256 cellar: :any,                 monterey:       "e987324d04bfe2505ba86583d2c2fd3011ab57f946e75ff82179a126c0901aff"
    sha256 cellar: :any,                 big_sur:        "5d8adc17ed018ac5a4f9db5b62466fe5a43de072a2156bfc7d190fcd072ee483"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c6ed098da41febed8864e81d27d264cadca8d99e55bfad0281d98c99e025790"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "hdf5"
  depends_on "netcdf"

  def install
    args = std_cmake_args + %w[-DBUILD_TESTING=OFF -DENABLE_TESTS=OFF -DENABLE_NETCDF_4=ON -DENABLE_DOXYGEN=OFF]

    system "cmake", "-S", ".", "-B", "build_shared", *args, "-DBUILD_SHARED_LIBS=ON"
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"

    system "cmake", "-S", ".", "-B", "build_static", *args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "build_static"
    lib.install "build_static/fortran/libnetcdff.a"

    # Remove shim paths
    inreplace [bin/"nf-config", lib/"libnetcdff.settings", lib/"pkgconfig/netcdf-fortran.pc"],
      Superenv.shims_path/ENV.cc, ENV.cc
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
