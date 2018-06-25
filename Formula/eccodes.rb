class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and  BUFR 3/4 formats"
  homepage "https://software.ecmwf.int/wiki/display/ECC/ecCodes+Home"
  url "https://software.ecmwf.int/wiki/download/attachments/45757960/eccodes-2.8.0-Source.tar.gz"
  sha256 "e0ba24c27cdd8133670fa3ea32be951d54030f2b880cacc9a9d87d9dbf372e1b"

  bottle do
    sha256 "72319e250c54c1d6b1d652123c8274a872fd6c790456ba198ec91ede2c1afb69" => :high_sierra
    sha256 "2f4b97fcdb043302d53e370df0faba8b258c91ba67ddff78cefbe8458f803567" => :sierra
    sha256 "654f8cf80796ef2a45d29b3bce3d258fffbe260ddd81c87b515b9c7c24246537" => :el_capitan
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
