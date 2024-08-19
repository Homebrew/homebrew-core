class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://confluence.ecmwf.int/download/attachments/45757960/eccodes-2.36.0-Source.tar.gz"
  sha256 "da74143a64b2beea25ea27c63875bc8ec294e69e5bd0887802040eb04151d79a"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/ECC/Releases"
    regex(/href=.*?eccodes[._-]v?(\d+(?:\.\d+)+)-Source\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "557e0ef44f04748e9d0e57453d1a968f68d66ada8640f0390715a556d19d13ed"
    sha256 arm64_ventura:  "5dbefb6d63c3a46b83cc239813cb5c5c07d47ca70bc78abb5f7212962b54d530"
    sha256 arm64_monterey: "9f7dc2f051ccb029df8915b382cb828cbeec3fd2545f19dfae07d13749521a10"
    sha256 sonoma:         "73ec2c2a93384cdb7f12c27b4efbcdb3cbbb4ab233a4b84902ff0a48e7a2f7be"
    sha256 ventura:        "4a16e7b8858ef4ee5dd697837d25b80054cccde0aa46b947e09801e1d6ec6452"
    sha256 monterey:       "62ce82e1205ed31b790ac255fdd99975ccac4c7093bdf96291763fa8b90499bd"
    sha256 x86_64_linux:   "aca7f1982b24d8a6e1b21e05f1ef711e7cb48833871979eda9bc5b1dbcc84dc9"
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
