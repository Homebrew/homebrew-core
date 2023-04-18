class NetcdfFortran < Formula
  desc "Fortran libraries and utilities for NetCDF"
  homepage "https://www.unidata.ucar.edu/software/netcdf/"
  url "https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v4.6.0.tar.gz"
  sha256 "8194aa70e400c0adfc456127c1d97af2c6489207171d13b10cd754a16da8b0ca"
  license "NetCDF"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a63583c813db6cc78b0193c3dda1cb9faef198f1f5690cc1041523c5089e2ff8"
    sha256 cellar: :any,                 arm64_monterey: "2218dea75ee32c7e5aa093c50c6557359865d1e7363497133b5f1666aff86025"
    sha256 cellar: :any,                 arm64_big_sur:  "e0cfebb70ac4e43ca906dc3211404d561d9a6097da04bb69616e0717c83cdf15"
    sha256 cellar: :any,                 ventura:        "159d8a3d3a608a5a8ba384c27ff3c5ad839334745d30a27b40e62a57f5a21a02"
    sha256 cellar: :any,                 monterey:       "84bd99b4eac569d656f1fd84be92533b5c659863e68093151761d69623a544eb"
    sha256 cellar: :any,                 big_sur:        "241ab9b78a55f618a4e65689d9b9f8d7aaea19411af7790ee2669da5fdb6c701"
    sha256 cellar: :any,                 catalina:       "416e9eecedeef6e400eab28158406647a3c860cac29601aeb17bcf87e770f419"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd412f6ad7303fceb3b21402da7ec4198ae5db913991ac712e4e0efb74ae557a"
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
