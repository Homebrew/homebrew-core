class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://confluence.ecmwf.int/download/attachments/45757960/eccodes-2.39.0-Source.tar.gz"
  sha256 "0c4d746700acc49af9c878925f1b26bdd42443ff7c2d7c676deb2babb6847afb"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/ECC/Releases"
    regex(/href=.*?eccodes[._-]v?(\d+(?:\.\d+)+)-Source\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "038b023ee6a1abb809cfd90a56f1a866c070c12ceb84205dd2ec6e993c007666"
    sha256 arm64_sonoma:  "bec847844e0379a2c1f7fd4b2f7662bc7055303071527f4d338e98162992f368"
    sha256 arm64_ventura: "8bb29dbe986c04b46e576e4ae4135ad2d12fd59155b2c5fb95c8f01586a689a3"
    sha256 sonoma:        "891bf650bf2adba6cc05c6a601af72eee52aeb437781ed1d7887a5a64872e385"
    sha256 ventura:       "b3462d8c871a3a731e3ca62bc5f7bfd3a8ed49053e794a7d33e2e0d3ecbe5f0a"
    sha256 x86_64_linux:  "3341656e4174c32fc58ad8f8c772030cbbd400e173069fbc031c42269a9284c8"
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
