class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://confluence.ecmwf.int/download/attachments/45757960/eccodes-2.33.0-Source.tar.gz"
  sha256 "bdcec8ce63654ec6803400c507f01220a9aa403a45fa6b5bdff7fdcc44fd7daf"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/ECC/Releases"
    regex(/href=.*?eccodes[._-]v?(\d+(?:\.\d+)+)-Source\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "09d2dd0df92abe72455f6c51bea3d274699fe1cd00e074f950ce1c2960a61b88"
    sha256 arm64_ventura:  "d3195cae8cbce7d8195c89b435a84aface19326e9aea58f1af5a6b0c13d045bd"
    sha256 arm64_monterey: "9661d95fad9908dde73a0d6e17d3ca7e7e515a67106246d5ed0488bb1c03a3da"
    sha256 sonoma:         "a2351386f187d98a6489355b3bd2a5cf33ea926ec72aa0c5b6db798ed1c84624"
    sha256 ventura:        "f36943e0cad218d5aae6eabe404efd1cda8c1cc97aad16a67390cea93c96ee8d"
    sha256 monterey:       "392d16b71c9a4e7c62df9a215a0160236105b927ca3480a65cea56cb0d78a82d"
    sha256 x86_64_linux:   "768ec1f3ff7727f121f138f8b5571093e8cace29ce09f390487496b2026d60d6"
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
