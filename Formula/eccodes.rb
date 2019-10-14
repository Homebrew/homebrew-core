class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://software.ecmwf.int/wiki/download/attachments/45757960/eccodes-2.13.1-Source.tar.gz"
  sha256 "158021539a85ca597075f4a534117721ea51f5ddea44b5ec27519d553c980f8d"

  bottle do
    sha256 "d9f55032952d2ec77fc71fa1e10a2fc0c8eb61035f13cf2964f91191fe510c30" => :catalina
    sha256 "e2176627399b50a2ff590e4bc4eb46992eac5535e5bc3614d6c6e52a8fbe781c" => :mojave
    sha256 "80af243cbb5b7c42529ef8d4efa783f57b8d9e8f4dad7367842715c922aec4a5" => :high_sierra
    sha256 "2a16c2a52726f0164f2c70f9ba56e0ebd8ed5738e0990ec085f07e65a08af7ea" => :sierra
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
