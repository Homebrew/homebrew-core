class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://confluence.ecmwf.int/download/attachments/45757960/eccodes-2.44.0-Source.tar.gz"
  sha256 "c75fb1f91b765b6b8b4774632a8a6fbcec96934db015fb63c2ad2560aedd443b"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/ECC/Releases"
    regex(/href=.*?eccodes[._-]v?(\d+(?:\.\d+)+)-Source\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "dbbc22710f3d548adbe674ebe3a920450e8c3f5176f8ca32438b7fcd6dc232b7"
    sha256 arm64_sequoia: "00872cc16ee30d1ab9778c72f5944ce4dae56ee092e42278edcb38edb1d6c5c9"
    sha256 arm64_sonoma:  "82a0939e0c9633304630270e6859ee1f9a230751f68fd6c044bbb96705619007"
    sha256 sonoma:        "f19bff6088b4b9903308de7e94e09cdec51c043baf9e6149d147af24269190fc"
    sha256 arm64_linux:   "6d6090fca0f9fd14f1627485f69afb39a38a3382af21ce908855923d0cd73cd5"
    sha256 x86_64_linux:  "c7e3c19815703ba55509ae4ee720ceeaf59c98fcedf4faf9a5d4bb80217cbdd5"
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
