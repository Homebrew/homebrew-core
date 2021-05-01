class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://software.ecmwf.int/wiki/download/attachments/45757960/eccodes-2.21.0-Source.tar.gz"
  sha256 "da0a0bf184bb436052e3eae582defafecdb7c08cdaab7216780476e49b509755"
  license "Apache-2.0"
  revision 3

  livecheck do
    url "https://software.ecmwf.int/wiki/display/ECC/Releases"
    regex(/href=.*?eccodes[._-]v?(\d+(?:\.\d+)+)-Source\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "5c7e83acc0f381fb2e85b1ce284cf636a5bd61f2c7004502987c1a0a3ac1025d"
    sha256 big_sur:       "536c81eed7426471c30781f56c015511b22a3cd591a354ad88ef3c4fda94ba2a"
    sha256 catalina:      "0ad7e0e5dc86dd7259e40de9c6caa982aed78ba722962566bc021da10b4a609b"
    sha256 mojave:        "3fe1d8a3c70dfa7b462851784cdfb87b2895a54583e4861c2db51a865dbea01e"
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
                            "-DENABLE_PYTHON=OFF", "-DENABLE_ECCODES_THREADS=ON",
                             *std_cmake_args
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
