class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://software.ecmwf.int/wiki/download/attachments/45757960/eccodes-2.12.0-Source.tar.gz"
  sha256 "f75ae5ce9e543622e8e40c3037619f8d9e6542c902933adb371bac82aee91367"

  bottle do
    rebuild 1
    sha256 "25e190988d76a375f1b60bfcede286ae59b5c6aeed3212b0097a2297cab81125" => :mojave
    sha256 "47b7c4aba9d4004726243e875778553430b00692c1ff7530e015591ff50a2b13" => :high_sierra
    sha256 "2af2351f9391cb6849aac21ef3a841e1f65465fe334c303a69b07fea8f8d31eb" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "jasper"
  depends_on "libpng"
  depends_on "netcdf"

  conflicts_with "grib-api",
    :because => "eccodes and grib-api install the same binaries."

  def install
    inreplace "CMakeLists.txt", "find_package( OpenJPEG )", ""

    mkdir "build" do
      system "cmake", "..", "-DENABLE_NETCDF=ON", "-DENABLE_PNG=ON", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    grib_samples_path = shell_output("#{bin}/codes_info -s").strip
    assert_match "packingType", shell_output("#{bin}/grib_ls #{grib_samples_path}/GRIB1.tmpl")
    assert_match "gridType", shell_output("#{bin}/grib_ls #{grib_samples_path}/GRIB2.tmpl")
  end
end
