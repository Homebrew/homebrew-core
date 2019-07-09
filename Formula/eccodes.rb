class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://software.ecmwf.int/wiki/download/attachments/45757960/eccodes-2.13.0-Source.tar.gz"
  sha256 "c5ce1183b5257929fc1f1c8496239e52650707cfab24f4e0e1f1a471135b8272"

  bottle do
    sha256 "5e06fab2d6e9bf162d09de8e3c487d33843575316e865ea0bf20eddb8a5ecca6" => :mojave
    sha256 "37cf436e3db67327716b1189225bfa2c3328da6d8964592a6772a45e21252b55" => :high_sierra
    sha256 "b17fa8c8024bd8e0f64338e342d1ace4276112dfc47c63041e868841ca440aa9" => :sierra
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
