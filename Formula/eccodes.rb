class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://confluence.ecmwf.int/download/attachments/45757960/eccodes-2.25.0-Source.tar.gz"
  sha256 "8975131aac54d406e5457706fd4e6ba46a8cc9c7dd817a41f2aa64ce1193c04e"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/ECC/Releases"
    regex(/href=.*?eccodes[._-]v?(\d+(?:\.\d+)+)-Source\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "5d5aacdec267608302dbc74e7654a14eb3fe21229a17f3cf6422a519a4c522d6"
    sha256 arm64_big_sur:  "8d3f7aaa3a2387feabe120e40bdb7b8fb82706c5ac16cde80595668187c38b17"
    sha256 monterey:       "f435e63f6f8fb21a13fb88173e0f01da1e973c7a9132ef0aaf724d3426f04983"
    sha256 big_sur:        "b8a219652c1d61ed4c1f2a6e39900cd4b978ea164ee3a0b0ee27502241dc49a3"
    sha256 catalina:       "a96ae3f672ab6720cdda192fcae658d26120e21c06053edd207ba327147bcd37"
    sha256 x86_64_linux:   "0363077a5224f60312b63210dab50d4fe89b6286d5d9836d42c2c150789c9183"
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
