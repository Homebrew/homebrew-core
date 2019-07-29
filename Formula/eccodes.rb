class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://software.ecmwf.int/wiki/download/attachments/45757960/eccodes-2.13.0-Source.tar.gz"
  sha256 "c5ce1183b5257929fc1f1c8496239e52650707cfab24f4e0e1f1a471135b8272"

  bottle do
    sha256 "08db3f50d225f9e82683f1916defc358b01485b248cde14051a803564cd79187" => :mojave
    sha256 "44e40d8a2a4d8512cd7082a02b7a31639a36fda30e6bf187d4f290e1be2090e3" => :high_sierra
    sha256 "526f8d2f4d85ec8c8d79ba2dfeebb38e49e46cfec8c23b017ed0d0b6a8cc2724" => :sierra
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
