class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://software.ecmwf.int/wiki/download/attachments/45757960/eccodes-2.18.0-Source.tar.gz"
  sha256 "d88943df0f246843a1a062796edbf709ef911de7269648eef864be259e9704e3"
  revision 1

  bottle do
    sha256 "752b23e86c8c5c54d1870ff3cee3adbb4f2bd3eb552c6a87073ba3867107354f" => :catalina
    sha256 "7b0366448047c170843a0519611acb03a6cdf10c6f67df6b6813514a8f2d8854" => :mojave
    sha256 "cf12c6c0ae154b545e8ca764a635a6df15ac0fba85eac7143a6564ca740283ed" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "jasper"
  depends_on "libpng"
  depends_on "netcdf"

  def install
    # Fix for GCC 10, remove with next version
    # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=957159
    ENV.prepend "FFLAGS", "-fallow-argument-mismatch"

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
