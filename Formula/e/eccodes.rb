class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://confluence.ecmwf.int/download/attachments/45757960/eccodes-2.31.0-Source.tar.gz"
  sha256 "808ecd2c11fbf2c3f9fc7a36f8c2965b343f3151011b58a1d6e7cc2e6b3cac5d"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/ECC/Releases"
    regex(/href=.*?eccodes[._-]v?(\d+(?:\.\d+)+)-Source\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "f096f5b6cc3368263f87f2045febc8f16ceee16243f0f11993011315aa2e192c"
    sha256 arm64_monterey: "30cee1db8c83cc01ca33a8155218872686603c4069df2d096b7bc368ce8323c6"
    sha256 arm64_big_sur:  "b56b7d22f554dcad15d693e6f4329cbc11732580c1648e62ba57a066fc3f2171"
    sha256 ventura:        "e54e9c95ac0d7178bbfb0e27c03f487ac0c2b70b81f2bb34d5de67aba0d4af69"
    sha256 monterey:       "134bf4b2d228e6b05b72bfb43685fbe2b7fabd391ab4909a29c6d109fd8476d1"
    sha256 big_sur:        "713e7df8253e9632a64c6554212ae418fe1ec3f80aa19fa0623b7151cc19cd45"
    sha256 x86_64_linux:   "8b0f7a231651764a349c061dd59769897ddc800831eeca8bdb2c8055c8a8d924"
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
