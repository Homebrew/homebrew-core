class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://confluence.ecmwf.int/download/attachments/45757960/eccodes-2.46.0-Source.tar.gz"
  sha256 "7d959253d5e34aeb16caa14d4889ac06486d19821216743142733a32ee7b4935"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/ECC/Releases"
    regex(/href=.*?eccodes[._-]v?(\d+(?:\.\d+)+)-Source\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "37b9d6e6e49c04b21a0be3e1351414898a434511a7e52337a12b57cb26fdda57"
    sha256 arm64_sequoia: "5762c78d6f7e417f30fadade383b9f4edb8f8130e3c1fb3d7cec1eef962c0c87"
    sha256 arm64_sonoma:  "64ab2b8634b6ebb6ff54a377cd255079e093acf6bffccf0b3c77eb8d84ac5b59"
    sha256 sonoma:        "e53bc7381039ff4240438f192a72b5d9adee0e606b9b167abede7a6e32c48d36"
    sha256 arm64_linux:   "4c8d68302ad80e7a3bf0aafef17954b33bf0be52fff0470ad61834a3d354b9c7"
    sha256 x86_64_linux:  "673fbba3fcb90f40306f9db14bf7a0a7a59de6fe9694f5727af38e45cd743826"
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
