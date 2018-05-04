class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and  BUFR 3/4 formats"
  homepage "https://software.ecmwf.int/wiki/display/ECC/ecCodes+Home"
  url "https://software.ecmwf.int/wiki/download/attachments/45757960/eccodes-2.7.0-Source.tar.gz"
  sha256 "118f46cf6f800585580a5bc838128537ab0879073e9fcded49cd374e4c8d8e6a"

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "jasper"
  depends_on "libpng"
  depends_on "numpy"

  def install
    inreplace "CMakeLists.txt", "find_package( OpenJPEG )", ""

    mkdir "build" do
      args = std_cmake_args

      system "cmake", "..", "-DENABLE_NETCDF=OFF", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    grib_samples_path = shell_output("#{bin}/codes_info -s").strip
    system bin/"grib_ls", "#{grib_samples_path}/GRIB1.tmpl"
    system bin/"grib_ls", "#{grib_samples_path}/GRIB2.tmpl"
  end
end
