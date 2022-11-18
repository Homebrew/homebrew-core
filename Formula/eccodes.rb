class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://confluence.ecmwf.int/download/attachments/45757960/eccodes-2.27.0-Source.tar.gz"
  sha256 "ede5b3ffd503967a5eac89100e8ead5e16a881b7585d02f033584ed0c4269c99"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/ECC/Releases"
    regex(/href=.*?eccodes[._-]v?(\d+(?:\.\d+)+)-Source\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "2c8287ec7ec83c5ce981b618e1a7a1b2fe8319cd4a539a79dad55b35d508691e"
    sha256 arm64_monterey: "dda92de3e5c0aa3b85e51660812593aaef9515621c812043e583c1f3b01196e5"
    sha256 arm64_big_sur:  "0aebf47fe8b76bc646aae05b112ba71235e5e0318712ab86eedb667ace6d51a4"
    sha256 ventura:        "a2844665e762a51f2a2b4c56c73d747a40d5e112d3c6b8b532ff8326c3393152"
    sha256 monterey:       "ba8b4677c0cf19963cdf54c4dd4eadf426e15e43d5f395ed2dbf6a50282626d7"
    sha256 big_sur:        "dcc5fa1823d0708af4581cba206faba6d893bff359e04fc50daa48547a74b8b3"
    sha256 catalina:       "b25268b098dad80115e4a320881d2c39fee1a0af22559aa3ccaa0f159eb45cc2"
    sha256 x86_64_linux:   "d46673a8c6e5c769093851c019c06cfe141868339231e7681a872ce3d813a7c7"
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
    inreplace shim_references, Superenv.shims_path/ENV.cc, ENV.cc
  end

  test do
    grib_samples_path = shell_output("#{bin}/codes_info -s").strip
    assert_match "packingType", shell_output("#{bin}/grib_ls #{grib_samples_path}/GRIB1.tmpl")
    assert_match "gridType", shell_output("#{bin}/grib_ls #{grib_samples_path}/GRIB2.tmpl")
  end
end
