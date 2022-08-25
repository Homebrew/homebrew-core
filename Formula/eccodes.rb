class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://confluence.ecmwf.int/download/attachments/45757960/eccodes-2.27.0-Source.tar.gz"
  sha256 "ede5b3ffd503967a5eac89100e8ead5e16a881b7585d02f033584ed0c4269c99"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/ECC/Releases"
    regex(/href=.*?eccodes[._-]v?(\d+(?:\.\d+)+)-Source\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "8d83570b17e9dab3ad4125b5596f9ac2b806b426351fa3130646b8dcac0c5659"
    sha256 arm64_big_sur:  "b7dd20c88359a7afe5f04f45d44b46738f526f70ddb207a692b81c2367e75d2c"
    sha256 monterey:       "a899181d44ad42b5b037353d854d3ea31c8a7c1eafe5cbd0b6be949f7d53ecb5"
    sha256 big_sur:        "5643132087326d70f36bb74c47075fa48d6bd28248f684ecf408a91a0e6dc360"
    sha256 catalina:       "3f9ddf6bb695214f721b2338f5a303ad726bd72cbe1496c0aacf9b8814e0814c"
    sha256 x86_64_linux:   "60d4a92c3e08b9770e6c3cfd46a5718823933c01840a5432a6985dc910e9cfa6"
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
