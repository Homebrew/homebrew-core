class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://confluence.ecmwf.int/download/attachments/45757960/eccodes-2.45.0-Source.tar.gz"
  sha256 "6c84b39d7cc5e3b8330eeabe880f3e337f9b2ee1ebce20ea03eecd785f6c39a1"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/ECC/Releases"
    regex(/href=.*?eccodes[._-]v?(\d+(?:\.\d+)+)-Source\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "5108626d4aa0fa24344ce665e5630ccd91d029db917a997c91856f1db4dd1b83"
    sha256 arm64_sequoia: "6ada842804f349d5b88f1fd3add93c174e979ad7bdd7b76b6ea91217e9858200"
    sha256 arm64_sonoma:  "07a68af38551d176d0125a43d3407aff39f363ec0b3f2b8b1c6acbac4c9e0011"
    sha256 sonoma:        "64c7b6c196da2e02f995c913e9b8d5ad86c9d2ee74330cf9e7f9f80a592bbd5d"
    sha256 arm64_linux:   "2c0d2689673cd265abb6267da8b53dd3c66f816ca19ecd40d34f58d1b3b55894"
    sha256 x86_64_linux:  "bef526071fc2c45c3f0385cc0437cf5bd7fc2e199b697a6dec6022efce078117"
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
