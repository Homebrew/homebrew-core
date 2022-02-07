class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://confluence.ecmwf.int/download/attachments/45757960/eccodes-2.24.2-Source.tar.gz"
  sha256 "c60ad0fd89e11918ace0d84c01489f21222b11d6cad3ff7495856a0add610403"
  license "Apache-2.0"
  revision 1

  livecheck do
    url "https://confluence.ecmwf.int/display/ECC/Releases"
    regex(/href=.*?eccodes[._-]v?(\d+(?:\.\d+)+)-Source\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "7c68f7fb5597d3ba6022e79d5f67f1d5d3b759a28fc8f7ffda9f32667eebd6e1"
    sha256 arm64_big_sur:  "6e17f66830348d52b23f71994003d8edc5865f519172706d3e26ed22a1aa51ea"
    sha256 monterey:       "e4c88fadaa482cf40e53fe71f76dc4d84a06d4ac26db61f671e63ff5db66750f"
    sha256 big_sur:        "3fbbc8dc7004e001684b7fc68182a893fc56dda1822e4f18bdc8e8db553ba079"
    sha256 catalina:       "a805da1c88f154c585052fb0aaa7e15296a4e62036ada3497aa76707621e68e1"
    sha256 x86_64_linux:   "f7486711b3219bdc5e198cf22dbf9476a88fb5337846c6eed7e0c1522f33231f"
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
