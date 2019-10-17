class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://software.ecmwf.int/wiki/download/attachments/45757960/eccodes-2.14.1-Source.tar.gz"
  sha256 "16da742691c0ac81ccc378ae3f97311ef0dfdc82505aa4c652eb773e911cc9d6"

  bottle do
    sha256 "518810cfb5ff75526393fef210bcd60d70169090f63bc8fa858bf685f7e68109" => :catalina
    sha256 "b347ae3d8c57c4ef16513c008ca686cc999876e03d4be0baeeddff5f1436e1d8" => :mojave
    sha256 "071ff462224c88c84f030708851f36950320bc64febc39471c3fa623fa847a02" => :high_sierra
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
