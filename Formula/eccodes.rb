class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://confluence.ecmwf.int/download/attachments/45757960/eccodes-2.24.1-Source.tar.gz"
  sha256 "e838523d8c895fcc0b7dfa7ee1ac107de70ec7456e80e46a8af013196f429e1e"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/ECC/Releases"
    regex(/href=.*?eccodes[._-]v?(\d+(?:\.\d+)+)-Source\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "cbfe3401b3058dbe3cd4dcd1700b70780afc23c9c5a292005d1a52c9443bfcb8"
    sha256 arm64_big_sur:  "a3c8819c95b11e9ddb98ca06c424a64671db941204fcc816c930117b136429a9"
    sha256 monterey:       "00ef78e15161964f3889702aafb61ae12838d836b14e51ac3cd5ff6ea7261b77"
    sha256 big_sur:        "81a6ddf2948a752f4d5cbd56f06143759f5c376000ba83ec43bbaea5bf40f94b"
    sha256 catalina:       "ccf2c0bebb12397bea98197a9b6d05bd2467eacf8fe26d89fc21fb44723c21f2"
    sha256 x86_64_linux:   "d6120881861702d0172c96d3f40ae6100480dd51bb0503e607ff3f636a1930ea"
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
                            "-DENABLE_PYTHON=OFF", "-DENABLE_ECCODES_THREADS=ON",
                             *std_cmake_args
      system "make", "install"
    end

    # Avoid references to Homebrew shims directory
    shim_references = [include/"eccodes_ecbuild_config.h", lib/"pkgconfig/eccodes.pc", lib/"pkgconfig/eccodes_f90.pc"]
    inreplace shim_references, Superenv.shims_path/ENV.cc, ENV.cc
  end

  test do
    grib_samples_path = shell_output("#{bin}/codes_info -s").strip
    assert_match "packingType", shell_output("#{bin}/grib_ls #{grib_samples_path}/GRIB1.tmpl")
    assert_match "gridType", shell_output("#{bin}/grib_ls #{grib_samples_path}/GRIB2.tmpl")
  end
end
