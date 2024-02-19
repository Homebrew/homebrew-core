class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://confluence.ecmwf.int/download/attachments/45757960/eccodes-2.34.0-Source.tar.gz"
  sha256 "3cd208c8ddad132789662cf8f67a9405514bfefcacac403c0d8c84507f303aba"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/ECC/Releases"
    regex(/href=.*?eccodes[._-]v?(\d+(?:\.\d+)+)-Source\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "326dc187186141ab64a555318f847e2bc78cd71749f42f69401210154b23c818"
    sha256 arm64_ventura:  "b8dab66b71e1168ab0aff9db75a52949a01ab969da5b532650092b436b8303d9"
    sha256 arm64_monterey: "6157865711d6ed287765a23d7d8e447e6761434e0faa3ac4a77f4e81e3e7ad54"
    sha256 sonoma:         "e7270264bdbd652af80f5a1b6c44fcb36a6b876ab2ffb9bf622b9d515af7b901"
    sha256 ventura:        "9047d3e2cb7f03be26af6fe0e8378f5e9d8844a10d1d065ad297721f5b90a1c3"
    sha256 monterey:       "a2e4f0c433c382fdeada06afabf4e32f0af19ab0a6c5a543b2b630bff85657c4"
    sha256 x86_64_linux:   "2cc86f1b11e59586726fc1cf0c0473bdac688c97a6d600c74e7865eca145ddcc"
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
