class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://confluence.ecmwf.int/download/attachments/45757960/eccodes-2.26.0-Source.tar.gz"
  sha256 "392f632612e16a8c0bb0b8f6d627cbc3f54e56f51ace05bceac368377ab52e49"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/ECC/Releases"
    regex(/href=.*?eccodes[._-]v?(\d+(?:\.\d+)+)-Source\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "8f24c6d5e58643ba457277fec2d9d91a1abc8c5d01f590c3663e0ab479741abe"
    sha256 arm64_big_sur:  "e48fa98ff3439844a0d6a33fcc274526d76fe7fae5a04348153480ce0e9acf08"
    sha256 monterey:       "6360864599f74464c5a8e1b92382647165e119debaa8dfd26b164c7b2ec41f51"
    sha256 big_sur:        "f182c991680c25b2cc2cd2d3742342477befc329c4f295d899c7e94febb098b3"
    sha256 catalina:       "f15f84fe2caf6330a28025647043173f89ab65165144b05fbc64eeef0ed7b776"
    sha256 x86_64_linux:   "6011b2eb7d7910c498fda1fe9b5dd8e3032ce2723a9cea21836dd47d17cc3244"
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
    inreplace shim_references, Superenv.shims_path/ENV.cc, ENV.cc
  end

  test do
    grib_samples_path = shell_output("#{bin}/codes_info -s").strip
    assert_match "packingType", shell_output("#{bin}/grib_ls #{grib_samples_path}/GRIB1.tmpl")
    assert_match "gridType", shell_output("#{bin}/grib_ls #{grib_samples_path}/GRIB2.tmpl")
  end
end
