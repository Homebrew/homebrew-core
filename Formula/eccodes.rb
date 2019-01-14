class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://software.ecmwf.int/wiki/download/attachments/45757960/eccodes-2.10.0-Source.tar.gz"
  sha256 "bea3cb4caafca368538bc457075bbe848215085f3574cfcdf106d32e954d82d8"

  bottle do
    sha256 "116835bc40fbeec77cd5fea00b64034621bab001a7bed3c50931518f0b91ea56" => :mojave
    sha256 "7e57dd5d695eeddf30447e6beebabfb3c4e71754b5bd38418ef7d1c7471c14dd" => :high_sierra
    sha256 "cf23afaaba4b4aba64650d3f291dfc0dda3ffc8c7ad4382147c3113bbb8141be" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "jasper"
  depends_on "libpng"

  conflicts_with "grib-api",
    :because => "eccodes and grib-api install the same binaries."

  def install
    inreplace "CMakeLists.txt", "find_package( OpenJPEG )", ""

    mkdir "build" do
      system "cmake", "..", "-DENABLE_NETCDF=OFF", "-DENABLE_PNG=ON", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    grib_samples_path = shell_output("#{bin}/codes_info -s").strip
    assert_match "packingType", shell_output("#{bin}/grib_ls #{grib_samples_path}/GRIB1.tmpl")
    assert_match "gridType", shell_output("#{bin}/grib_ls #{grib_samples_path}/GRIB2.tmpl")
  end
end
