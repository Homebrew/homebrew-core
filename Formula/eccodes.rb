class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://confluence.ecmwf.int/download/attachments/45757960/eccodes-2.30.2-Source.tar.gz"
  sha256 "39b95e4221b116dc818656d04c82884055d48aebaa2990c259ea8cdffda42582"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/ECC/Releases"
    regex(/href=.*?eccodes[._-]v?(\d+(?:\.\d+)+)-Source\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "360051dd0d1e40e5eba5c7f7f41dfa38a9e9223c734a300d9c3d414c5cb94f9d"
    sha256 arm64_monterey: "95a261aa112fdd619eda879005760a588bae0b51ac3dc28f9e81e0470dba0d8b"
    sha256 arm64_big_sur:  "2628ae3e5582f5bd2e5a78e07aedd77019275b2da26b31a36f5c6fd323b81435"
    sha256 ventura:        "177d9551ba5ef7ea1b03456932809a492b8a3097c80d439a2409c2ae3bb46fd4"
    sha256 monterey:       "28ff02b9b506367ec41394f956745b0e330c12cd983efc905f9c0a6adc06ae99"
    sha256 big_sur:        "6910f19a9a1995bb6432e86ee87ad57f9f884834727342bd017e6462e5b52e44"
    sha256 x86_64_linux:   "8eb9a92519e48a0affccb6ff85347777c88e1a3665f52276d2b2e44289ad17bf"
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
