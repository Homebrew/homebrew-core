class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://confluence.ecmwf.int/download/attachments/45757960/eccodes-2.34.1-Source.tar.gz"
  sha256 "f9b8680122e3ccec26e6ed24a81f1bc50ed9f2232b431e05e573678aac4d9734"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/ECC/Releases"
    regex(/href=.*?eccodes[._-]v?(\d+(?:\.\d+)+)-Source\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "83c027279ebd3453866ef5faace06890747507acd9e20117d6caef2f542871c7"
    sha256 arm64_ventura:  "5aeea752c1ca6a4e435f4e7991b716069445c5be0a2c7ee740f952c504cb2405"
    sha256 arm64_monterey: "18833d858877f6179f17cc40fa6e85f54539ea7453959e5aa61d91eb3a2e5e43"
    sha256 sonoma:         "a56d05454ec77611486c01a2d68a6b8548cac05cd7e70536d08c6904bc0ab9e3"
    sha256 ventura:        "07c3876133b9cdb1dcb31e9865cfdb0bbe70430cff8c6efebccbc3316eee0645"
    sha256 monterey:       "be48e3c6cc38e14b55ae36c151fd30f8aa7f1d576b35f9bcd7eb35edcce44747"
    sha256 x86_64_linux:   "95ad046369a092c96cff53a16946bfa9d45e850fd9c4041930f6226b8a9d49a7"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "libpng"
  depends_on "netcdf"
  depends_on "openjpeg"

  def install
    mkdir "build" do
      system "cmake", "..", "-DENABLE_NETCDF=ON",
                            "-DENABLE_FORTRAN=ON",
                            "-DENABLE_PNG=ON",
                            "-DENABLE_JPG=ON",
                            "-DENABLE_JPG_LIBOPENJPEG=ON",
                            "-DENABLE_JPG_LIBJASPER=OFF",
                            "-DENABLE_PYTHON=OFF",
                            "-DENABLE_ECCODES_THREADS=ON",
                             *std_cmake_args
      system "make", "install"
    end

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
