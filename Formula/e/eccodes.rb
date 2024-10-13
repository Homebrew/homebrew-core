class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://confluence.ecmwf.int/download/attachments/45757960/eccodes-2.38.0-Source.tar.gz"
  sha256 "96a21fbe8ca3aa4c31bb71bbd378b7fd130cbc0f7a477567d70e66a000ff68d9"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/ECC/Releases"
    regex(/href=.*?eccodes[._-]v?(\d+(?:\.\d+)+)-Source\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "ae410b8558ea1532bdd6337af562a6e6f883c6ad191d94b9489a028150f13dee"
    sha256 arm64_sonoma:  "c05e4f4574f59d5afb6c7f1f97cfe3cbb321ec85c9e22ee03e7f349f91df947a"
    sha256 arm64_ventura: "4de82d9ff57f10a0f8c26dbcb14a545e212b67cd36ee44af6706d813e6f50f3b"
    sha256 sonoma:        "eb8e82509b5fec9ad5a3062325788bfd7744c6348b0385d14bcafddd525587ab"
    sha256 ventura:       "dc60d8fe6dcbbec9bc2e02d703df282baf89e386304f3372eae397af6c4d2b4e"
    sha256 x86_64_linux:  "a55b7bee0733fdbe476934782272d5516842b1da2b6d0c312274eaf9eb36dc19"
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
