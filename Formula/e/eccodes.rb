class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://confluence.ecmwf.int/download/attachments/45757960/eccodes-2.32.0-Source.tar.gz"
  sha256 "b57e8eeb0eba0c05d66fda5527c4ffa84b5ab35c46bcbc9a2227142973ccb8e6"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/ECC/Releases"
    regex(/href=.*?eccodes[._-]v?(\d+(?:\.\d+)+)-Source\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "1fb79a757ea2f61dec79b0c5d4cd7a5d24ee429a4f2862b755795c7be7858de8"
    sha256 arm64_ventura:  "2dae75abcf445db6c102fae1421e5f2f2d57531f448483dca6e9c22608132328"
    sha256 arm64_monterey: "45add9c09cb202ce5667bead8e420a46760d16ee71563e622f70cfa6a7ebedc1"
    sha256 sonoma:         "983f6b6b4e855ba9fca7aca5334cdc862e6cf2519995e88c72be70720689ac55"
    sha256 ventura:        "dd2fcd521de6f45072c630230b13954040f7c44c758b992a89bac11b7751bffb"
    sha256 monterey:       "6e7393ba2de1cd791c315d9362311f1652ccd00579c0b76c294f1fc56108e683"
    sha256 x86_64_linux:   "ad9e387206b7a32634a05d98033d7806494c3d82172cda494ddd04e78d798b7a"
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
