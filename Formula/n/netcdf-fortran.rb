class NetcdfFortran < Formula
  desc "Fortran libraries and utilities for NetCDF"
  homepage "https://www.unidata.ucar.edu/software/netcdf/"
  url "https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v4.6.1.tar.gz"
  sha256 "40b534e0c81b853081c67ccde095367bd8a5eead2ee883431331674e7aa9509f"
  license "NetCDF"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e9798dfd835b908c9580046e00d5e096b10a60565cd24d231a2ef74f2fcb2964"
    sha256 cellar: :any,                 arm64_sonoma:  "2b0d549474c4bdf670ea0688c9a0711a81e904ae20ba2a400e0a618fd3f28e0b"
    sha256 cellar: :any,                 arm64_ventura: "ae2c7a62ac4c6c236ae8f5b641346c9f4472018c1c775370da955b94fe28ca0a"
    sha256 cellar: :any,                 sonoma:        "0cb1829fd3a86a2a018b517bb42360a1390e34d1112e65168a6317b249c0bcad"
    sha256 cellar: :any,                 ventura:       "ac11a65a396284b3b834bfe7e76ef7d55dd3c673e8aa53ddcc161872d13626d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65cb973811a732c8ebe5f1d8bebe7210495534c4e5ebec18003718c6347dddd5"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "hdf5"
  depends_on "netcdf"

  def install
    args = std_cmake_args + %w[-DENABLE_TESTS=OFF -DENABLE_NETCDF_4=ON -DENABLE_DOXYGEN=OFF]

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
    inreplace [bin/"nf-config", lib/"libnetcdff.settings", lib/"pkgconfig/netcdf-fortran.pc"],
      Superenv.shims_path/ENV.cc, ENV.cc
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
