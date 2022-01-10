class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://confluence.ecmwf.int/download/attachments/45757960/eccodes-2.24.1-Source.tar.gz"
  sha256 "e838523d8c895fcc0b7dfa7ee1ac107de70ec7456e80e46a8af013196f429e1e"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/ECC/Releases"
    regex(/href=.*?eccodes[._-]v?(\d+(?:\.\d+)+)-Source\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "f3618afa1512d7449b7fd45c850723838ffa9de86c3d2104eb777d7dc4c3ef8d"
    sha256 arm64_big_sur:  "b6ddb4df495f2bd573aaf0df732617967a1876413e412c3163b54940081379cf"
    sha256 monterey:       "c5f8650516b0dfd7f4e4a988c7146654b2d99d87d6388396efc18c85bcb4f017"
    sha256 big_sur:        "9e591567d52b615591e603fedba32805e61115bc5b0128e24fe9a477ca1edf7e"
    sha256 catalina:       "0b43666c1ef6df3903dbf161ecc1fb7993fd5913b56c2c27d1afcd1e9d7c8a49"
    sha256 x86_64_linux:   "c6d6b78657ce5c4abcb56a0f987584dc877bd93ba4c746f8c1fded15ac33fff7"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "jasper"
  depends_on "libpng"
  depends_on "netcdf"

  def install
    inreplace "CMakeLists.txt", "find_package( OpenJPEG )", ""

    mkdir "build" do
      system "cmake", "..", "-DENABLE_NETCDF=ON", "-DENABLE_PNG=ON",
                            "-DENABLE_PYTHON=OFF", "-DENABLE_ECCODES_THREADS=ON",
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
