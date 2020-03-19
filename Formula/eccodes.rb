class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://software.ecmwf.int/wiki/download/attachments/45757960/eccodes-2.17.0-Source.tar.gz"
  sha256 "762d6b71993b54f65369d508f88e4c99e27d2c639c57a5978c284c49133cc335"

  bottle do
    sha256 "bde5f768114c38b8d5e574a8698cd0389ed39353434ee5603baf236c88d8135c" => :catalina
    sha256 "63492c62b1efd61f676e971286ceb1cf511e28b14e41b39ab45214e450e1a02e" => :mojave
    sha256 "2e4b2ace8b0b151da83876f2ec4089b8643920faa5c3b2082393917a8b97d4f1" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "jasper"
  depends_on "libpng"
  depends_on "netcdf"

  def install
    inreplace "CMakeLists.txt", "find_package( OpenJPEG )", ""

    mkdir "build" do
      system "cmake", "..", "-DENABLE_NETCDF=ON", "-DENABLE_PNG=ON",
                            "-DENABLE_PYTHON=OFF", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    grib_samples_path = shell_output("#{bin}/codes_info -s").strip
    assert_match "packingType", shell_output("#{bin}/grib_ls #{grib_samples_path}/GRIB1.tmpl")
    assert_match "gridType", shell_output("#{bin}/grib_ls #{grib_samples_path}/GRIB2.tmpl")
  end
end
