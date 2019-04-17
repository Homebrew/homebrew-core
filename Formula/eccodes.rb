class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://software.ecmwf.int/wiki/download/attachments/45757960/eccodes-2.12.0-Source.tar.gz"
  sha256 "f75ae5ce9e543622e8e40c3037619f8d9e6542c902933adb371bac82aee91367"

  bottle do
    sha256 "206d6ce9f403dae9f4c99ce23c8148a8d66ab8b60d436f6258a0b1d5ca7e9590" => :mojave
    sha256 "7612ef3aa9fbc4360126e41440262bae526832f78b69976a6e4cdfff3b3c11e1" => :high_sierra
    sha256 "26bc88ede8825c8ee97b8fd79440c6800017842e8da789ae04df27d2df9c8dc3" => :sierra
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
