class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://confluence.ecmwf.int/download/attachments/45757960/eccodes-2.29.0-Source.tar.gz"
  sha256 "985b14cdccb32503182322d99edfa15adbff5c3cc3c7718eb9c6533d32e74918"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/ECC/Releases"
    regex(/href=.*?eccodes[._-]v?(\d+(?:\.\d+)+)-Source\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "9eb348881d626c2df435b57c07e5213aea40cf52a60af1e8eb131464a3329c15"
    sha256 arm64_monterey: "b59a81cbaacfb8736ff9eddfb244cbb8f4c64b6f10c33fa8f315745474993a4c"
    sha256 arm64_big_sur:  "8cf32d8536cf5ea530c53e3f4b4cc2d9fcf66c70b601d18aa699d14fc145f9f9"
    sha256 ventura:        "cc61e0bae77abf802c8c74c55b2567e93e6fa1c56e9d65e2cb51ca3f9882bd52"
    sha256 monterey:       "846d737ab7473becb33fef13ccf8a4beb9f6abdce25f1c09e4ab998a1ec7ebc2"
    sha256 big_sur:        "309694c64f415a8d0a02ef369b0bca9099c1f03e29d1e82b82f7d13d30380a8f"
    sha256 x86_64_linux:   "aee1934748c3f33c97a68c87b5658119b3ad6b14b17af87f22d7bf6e1f8f1c93"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "libpng"
  depends_on "netcdf"
  depends_on "openjpeg"

  def install
    mkdir "build" do
      system "cmake", "..", "-DENABLE_NETCDF=ON",
                            "-DENABLE_FORTRAN=ON",
                            "-DENABLE_PNG=ON",
                            "-DENABLE_JPG=ON",
                            "-DENABLE_JPG_LIBOPENJPEG=ON",
                            "-DENABLE_JPG_LIBJASPER=OFF",
                            "-DENABLE_PYTHON=OFF",
                            "-DENABLE_ECCODES_THREADS=ON",
                             *std_cmake_args
      system "make", "install"
    end

    # Avoid references to Homebrew shims directory
    shim_references = [include/"eccodes_ecbuild_config.h", lib/"pkgconfig/eccodes.pc", lib/"pkgconfig/eccodes_f90.pc"]
    inreplace shim_references, Superenv.shims_path/ENV.cxx, ENV.cxx
    inreplace shim_references, Superenv.shims_path/ENV.cc, ENV.cc
  end

  test do
    grib_samples_path = shell_output("#{bin}/codes_info -s").strip
    assert_match "packingType", shell_output("#{bin}/grib_ls #{grib_samples_path}/GRIB1.tmpl")
    assert_match "gridType", shell_output("#{bin}/grib_ls #{grib_samples_path}/GRIB2.tmpl")
  end
end
