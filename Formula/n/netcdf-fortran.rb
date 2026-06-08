class NetcdfFortran < Formula
  desc "Fortran libraries and utilities for NetCDF"
  homepage "https://www.unidata.ucar.edu/software/netcdf/"
  url "https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v4.6.3.tar.gz"
  sha256 "b9de820c4823faa5b4e1cd9ee82dd7c57acad105ebd8f6ae36b0244105518655"
  license "NetCDF"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5f1b8277d206e779d924f92d2637954146c7e045e147a3a086ae9a669e3c8c4d"
    sha256 cellar: :any, arm64_sequoia: "f0c35337e9ab38465da2b975b3a615a8c4b56b784f1c7a754d0a9ca5b2ee1136"
    sha256 cellar: :any, arm64_sonoma:  "ddff329a9a4c829f3bf8cfc2273c593474d6f7da6f443b37ea6bd637b1619e1e"
    sha256 cellar: :any, sonoma:        "b60f6e3a9ef7c6c66ba7f521f7a2d9e78b18ce88caa1ee4d805992b64ceee16d"
    sha256 cellar: :any, arm64_linux:   "1a4b712718fdf312416e72be967f4fc8b07c0bb3423bd95bff70c8864d96f47c"
    sha256 cellar: :any, x86_64_linux:  "731da1407870a2d94ae1855349daed9c07895463831a44ba6ebbd426957237b0"
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
