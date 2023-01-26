class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://confluence.ecmwf.int/download/attachments/45757960/eccodes-2.28.0-Source.tar.gz"
  sha256 "2831347b1517af9ebd70dd3cad88ae818a8448d4e6c8671aa728617e73431cd5"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/ECC/Releases"
    regex(/href=.*?eccodes[._-]v?(\d+(?:\.\d+)+)-Source\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "6baf1e629a44c54cf58d25a7ae5723053d03d8f076836dc094dafa2ec7f8c969"
    sha256 arm64_monterey: "6f0e7432723a8a05e40ef42f22d27191efae2b00b36e249b6ae881639a223186"
    sha256 arm64_big_sur:  "0071754b1112f0c3f2ce884e7a9007c72a7598cac0948c244e20650a3dc441ae"
    sha256 ventura:        "6ffdf03a49e114af585c94061e49ddf0a348f9dc47df4fb8464798dcc017324c"
    sha256 monterey:       "f685579541f0c36ea9c90d182244862d2baec22539e7cac83d68a3949a43b687"
    sha256 big_sur:        "91d4bfad8df020707ae102ab299fef722a36396acbd515f286e2e9b5ff36cced"
    sha256 x86_64_linux:   "512318c8588065048ceb6e46c486af5ef7c70e506d7b95f1303919c71dcd7042"
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
