class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and  BUFR 3/4 formats"
  homepage "https://software.ecmwf.int/wiki/display/ECC/ecCodes+Home"
  url "https://software.ecmwf.int/wiki/download/attachments/45757960/eccodes-2.8.0-Source.tar.gz"
  sha256 "e0ba24c27cdd8133670fa3ea32be951d54030f2b880cacc9a9d87d9dbf372e1b"

  bottle do
    sha256 "cd97957bebc77e3ef8b03398570640369804b0ea2caa8ee5a6e2b4bf18b88f01" => :high_sierra
    sha256 "7c7831f824cc178a50cf2d7fc81bb78cdfcd9c0afcf1d9fb644ef64a16ca6c51" => :sierra
    sha256 "c830d0214495a9f7804559185521fa261dbd5087a26fdeeb4786f8e99b74dc58" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "jasper"
  depends_on "libpng"
  depends_on "numpy"

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
