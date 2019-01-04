class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://software.ecmwf.int/wiki/download/attachments/45757960/eccodes-2.10.0-Source.tar.gz"
  sha256 "bea3cb4caafca368538bc457075bbe848215085f3574cfcdf106d32e954d82d8"

  bottle do
    sha256 "c4f8455e0c83cbbeb780eacdd6bd11589a8acc98b655a9e1d46bb00aac654588" => :mojave
    sha256 "f7e078f54c455461daf8fc9380f464eef78fd47349304312c5705a21f5136fef" => :high_sierra
    sha256 "6f52dde3cc19cf888118734f53d568fccb0fa6c6e5e71fff60974ebc4a667e5b" => :sierra
    sha256 "0eae38514c8ebed471f33c6d8824d2272ebf41ebd76092d35d9938fbacbca61c" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "jasper"
  depends_on "libpng"

  conflicts_with "grib-api",
    :because => "eccodes and obsolete grib-api install the same binaries."

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
