class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://software.ecmwf.int/wiki/download/attachments/45757960/eccodes-2.18.0-Source.tar.gz"
  sha256 "d88943df0f246843a1a062796edbf709ef911de7269648eef864be259e9704e3"

  bottle do
    sha256 "4e6dbef0ba2bac100a7b7da2e13085156910d3502d39c55cc09cfe1f6a6c966a" => :catalina
    sha256 "09b210f83213b211be709e91c9c208b2881a57e0155dc3a5708b95d930141d8a" => :mojave
    sha256 "e9d09fbe285c1e85e2481e992a2a494d814030c8346e9eb8ab3080420a7d6b8c" => :high_sierra
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

    # Avoid references to Homebrew shims directory
    inreplace include/"eccodes_ecbuild_config.h", HOMEBREW_LIBRARY/"Homebrew/shims/mac/super/clang", "/usr/bin/clang"
    inreplace lib/"pkgconfig/eccodes.pc", HOMEBREW_LIBRARY/"Homebrew/shims/mac/super/clang", "/usr/bin/clang"
    inreplace lib/"pkgconfig/eccodes_f90.pc", HOMEBREW_LIBRARY/"Homebrew/shims/mac/super/clang", "/usr/bin/clang"
  end

  test do
    grib_samples_path = shell_output("#{bin}/codes_info -s").strip
    assert_match "packingType", shell_output("#{bin}/grib_ls #{grib_samples_path}/GRIB1.tmpl")
    assert_match "gridType", shell_output("#{bin}/grib_ls #{grib_samples_path}/GRIB2.tmpl")
  end
end
