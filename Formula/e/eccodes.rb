class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://confluence.ecmwf.int/download/attachments/45757960/eccodes-2.35.0-Source.tar.gz"
  sha256 "16888fb6679b1e241f50b69f300ac50124a3192342ae2ea903d7621b664e79ea"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/ECC/Releases"
    regex(/href=.*?eccodes[._-]v?(\d+(?:\.\d+)+)-Source\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "d47b00615ab84f7a09c6d0ddd325128a9bc0006d3412ecb26ac0df75163cfa1b"
    sha256 arm64_ventura:  "2785624d6f4aa1a28d6dff906e771d9acbd16b08ab33250147a1169a1c1e8459"
    sha256 arm64_monterey: "f53950785a13fe44aedb8f4690e421c48e7cdb1a3286a9f7dec5e06508c8fab2"
    sha256 sonoma:         "421b5f55183f0c1de343041cc00ecb5a642ba97f26c318693c31d6dc7513877e"
    sha256 ventura:        "54063555548f85c692e96ab5027a58dcced7e419e92b592ff87724e200786081"
    sha256 monterey:       "61cc4d30dec0879381d0980050ebd8aefdb5ebe0b0e7795e92217f1a162cc5f2"
    sha256 x86_64_linux:   "90e7ec4042c2fc479ba3714f244db4b63158cef9f928b8d6de4d2ac6cbd3d2a2"
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
