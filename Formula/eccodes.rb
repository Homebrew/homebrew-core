class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://software.ecmwf.int/wiki/download/attachments/45757960/eccodes-2.17.0-Source.tar.gz"
  sha256 "762d6b71993b54f65369d508f88e4c99e27d2c639c57a5978c284c49133cc335"

  bottle do
    sha256 "30d7d624aff97a5a9d75520fbeefc157f619e468169c3d813cd1506bd0c3dd1b" => :catalina
    sha256 "57b799b93c7211206b93445ac91700cb8ba559ab7c2f0dcbd8679ae6e41e0f94" => :mojave
    sha256 "c9a369d43375af207cbd90d6c148552d04341a79d67b4fa1e4126c17813c3bd0" => :high_sierra
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
