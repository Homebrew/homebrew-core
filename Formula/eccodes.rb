class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://confluence.ecmwf.int/download/attachments/45757960/eccodes-2.30.0-Source.tar.gz"
  sha256 "b3dc9389d05841a2e9c957aa520988a54c2605163de64b7e73c084aaed1fc3c4"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/ECC/Releases"
    regex(/href=.*?eccodes[._-]v?(\d+(?:\.\d+)+)-Source\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "df0d8fa89aa27e3a40551c277c715d6e570f6008fc58c7923016c9b8ce6604a4"
    sha256 arm64_monterey: "92a6c17c1ed52a93ebbebb5bcb2a4cd0e52459c5f034c0ebf576a4389a6c5409"
    sha256 arm64_big_sur:  "0bee86e828ab87d72160e8975f7cb0733698bcb05d0a6a3e1b7206b5fe234b02"
    sha256 ventura:        "9b91ab7801353f4a4122de2600c449177a89adc9fcf3bdad6217146601a5a53a"
    sha256 monterey:       "5851807a45ccc73d4df9a1fe87d04e3c5939427d72272d73bf71de9bd9531e16"
    sha256 big_sur:        "bdb6da406cd0224798eded0536efb4c37e97a44ce8897d31416526b9afbfcbda"
    sha256 x86_64_linux:   "963d255e8fe3120f56f30955c20820b36e0d1ee8b44ee3cdc592a22a4450573c"
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
