class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://confluence.ecmwf.int/download/attachments/45757960/eccodes-2.41.0-Source.tar.gz"
  sha256 "a1467842e11ed7f62a2f5cc1982e04eec62398f4962e6ba03ace7646f32cf270"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/ECC/Releases"
    regex(/href=.*?eccodes[._-]v?(\d+(?:\.\d+)+)-Source\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "3dee9ba650deb490a8c1dc28a9f4a4d8ed7b613e82d6b94f27333c2a8dc58f6d"
    sha256 arm64_sonoma:  "d0979389091aad166577991ca34245f661e4c103fb0501505e9d8e2fbb31f471"
    sha256 arm64_ventura: "909ce2ee8a04c627e87dd2ac425a50262621f8d7d08062d826d8095bc2c81ca7"
    sha256 sonoma:        "926d2786b0963ae4ea7970c8ee4d8b7ab0146707e776a4ce4d388ec148f89ac0"
    sha256 ventura:       "01eccbc10aa5bd328313dcae5458a50190adcdb636d6aa87c047ef37faa398b4"
    sha256 arm64_linux:   "9dc4ce6547b50f676b64f2fd50b180485fe76267b9e052c246f24f2cc05fef4d"
    sha256 x86_64_linux:  "d97dcd615771d1ea7a55c62d760de3153183475fb7d2350b5eab23ca13545f3f"
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
