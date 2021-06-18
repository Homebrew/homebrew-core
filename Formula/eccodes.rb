class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://software.ecmwf.int/wiki/download/attachments/45757960/eccodes-2.22.1-Source.tar.gz"
  sha256 "75c7ee96469bb30b0c8f7edbdc4429ece4415897969f75c36173545242bc9e85"
  license "Apache-2.0"

  livecheck do
    url "https://software.ecmwf.int/wiki/display/ECC/Releases"
    regex(/href=.*?eccodes[._-]v?(\d+(?:\.\d+)+)-Source\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "6f24b97b7b1d34d33e705983934f362b6c866b451ab49d633c6000ac345f6c5e"
    sha256 big_sur:       "9b62e4fa0c735bb2a53b342ec94df6b918595bae35e331aca09eba54e75d7f9e"
    sha256 catalina:      "7e265372d91110d9c9e315ebb711d481761a29d1409e79e59f483d4cd4b7a364"
    sha256 mojave:        "e460ff92d1f1dde670f787c6b79afd41a043445a5f00ccd13ead2f4d53bd5d5c"
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
    shim_references = [include/"eccodes_ecbuild_config.h", lib/"pkgconfig/eccodes.pc", lib/"pkgconfig/eccodes_f90.pc"]
    inreplace shim_references, %r{#{HOMEBREW_SHIMS_PATH}/[^/]+/super/#{ENV.cc}}, ENV.cc
  end

  test do
    grib_samples_path = shell_output("#{bin}/codes_info -s").strip
    assert_match "packingType", shell_output("#{bin}/grib_ls #{grib_samples_path}/GRIB1.tmpl")
    assert_match "gridType", shell_output("#{bin}/grib_ls #{grib_samples_path}/GRIB2.tmpl")
  end
end
