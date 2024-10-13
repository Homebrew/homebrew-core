class NetcdfFortran < Formula
  desc "Fortran libraries and utilities for NetCDF"
  homepage "https://www.unidata.ucar.edu/software/netcdf/"
  url "https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v4.6.1.tar.gz"
  sha256 "40b534e0c81b853081c67ccde095367bd8a5eead2ee883431331674e7aa9509f"
  license "NetCDF"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8b62a93777fedd65dc1fb67b84cde354588dab2352f216f89930aec00ed768f6"
    sha256 cellar: :any,                 arm64_sonoma:  "993ceaa41b2e1fc8710ca48606136ff18f6bde953f563719b60528929b910a04"
    sha256 cellar: :any,                 arm64_ventura: "17d6a2cf65bfdc1842136df9c62789b4ec21783d3989309bc795d7859235dd4b"
    sha256 cellar: :any,                 sonoma:        "28c45ad6a04dc865332cb5ab992c24b595a0282263d8990a9b8d2f2441840a9b"
    sha256 cellar: :any,                 ventura:       "5243be662389c3f85b0dc96d90cd6706dd2ff7393c493af3dbc3dbaab6a8a8fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b555cd5b1f9e6486a6804214836de433c9f97b118ba76d073949d37990f1da40"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "hdf5"
  depends_on "netcdf"

  def install
    args = std_cmake_args + %w[-DBUILD_TESTING=OFF -DENABLE_TESTS=OFF -DENABLE_NETCDF_4=ON -DENABLE_DOXYGEN=OFF]

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
