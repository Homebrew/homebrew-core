class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://software.ecmwf.int/wiki/download/attachments/45757960/eccodes-2.15.0-Source.tar.gz"
  sha256 "9fec8ad11f380795af632fb3105c4aa37d30f22fa70dba48fd93324cf6388d59"

  bottle do
    sha256 "4fc6f61a8964aeb44d1ef5797d3f4504039ddd718567965c000dc2ee49f58b3c" => :catalina
    sha256 "747cf33b6f49ed3a7a703bb6c9037724025d9c468c49d3e3fbd4e34324f6f4c7" => :mojave
    sha256 "0edcf85b1d1e660005dcdd00e627d462f221a300257bc4bda581888467175169" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "jasper"
  depends_on "libpng"
  depends_on "netcdf"

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
