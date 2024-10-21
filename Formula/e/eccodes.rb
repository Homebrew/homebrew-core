class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://confluence.ecmwf.int/download/attachments/45757960/eccodes-2.38.3-Source.tar.gz"
  sha256 "fa7b7ffb22973ed1dfbeb208c042a67a805ab070f1288a0f1f0707a1020d1c81"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/ECC/Releases"
    regex(/href=.*?eccodes[._-]v?(\d+(?:\.\d+)+)-Source\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "104afd7a17b4b5d749fa9a7a54511501026036aaf8bffa132065fe3685630286"
    sha256 arm64_sonoma:  "26cbcb3e8a5e3f11eb0ea25e460c3a7106eb232faedc0666761f8640b3e4b5d6"
    sha256 arm64_ventura: "e932a9059f36bc5ba8d8086501f3b09d0b9520d03c7dd80800756beabc2c0761"
    sha256 sonoma:        "18ddf3ebf2f29f72853399ac7d7998c0da2a0eb85e3084e7ccf7705a52bf3c9d"
    sha256 ventura:       "0dbc8e21456ba8effd6e91ab354bd6608b6a1abd251b272825a4bf9f0bcf16b1"
    sha256 x86_64_linux:  "690ca4b2ec328d7868573ade44c8b6ff6731f82ac0eccac9d9c2e74c8ddff634"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "libaec"
  depends_on "libpng"
  depends_on "netcdf"
  depends_on "openjpeg"

  def install
    args = %w[
      -DENABLE_NETCDF=ON
      -DENABLE_FORTRAN=ON
      -DENABLE_PNG=ON
      -DENABLE_JPG=ON
      -DENABLE_JPG_LIBOPENJPEG=ON
      -DENABLE_JPG_LIBJASPER=OFF
      -DENABLE_ECCODES_THREADS=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Avoid references to Homebrew shims directory
    shim_references = [include/"eccodes_ecbuild_config.h", lib/"pkgconfig/eccodes.pc", lib/"pkgconfig/eccodes_f90.pc"]
    inreplace shim_references, Superenv.shims_path/ENV.cxx, ENV.cxx
    inreplace shim_references, Superenv.shims_path/ENV.cc, ENV.cc
  end

  test do
    grib_samples_path = shell_output("#{bin}/codes_info -s").strip
    assert_match "packingType", shell_output("#{bin}/grib_ls #{grib_samples_path}/GRIB1.tmpl")
    assert_match "gridType", shell_output("#{bin}/grib_ls #{grib_samples_path}/GRIB2.tmpl")
  end
end
