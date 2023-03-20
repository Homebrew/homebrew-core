class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://confluence.ecmwf.int/download/attachments/45757960/eccodes-2.29.0-Source.tar.gz"
  sha256 "985b14cdccb32503182322d99edfa15adbff5c3cc3c7718eb9c6533d32e74918"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/ECC/Releases"
    regex(/href=.*?eccodes[._-]v?(\d+(?:\.\d+)+)-Source\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "1cf581148e5a4699f53f6ced87da75e08f09d16a0534a4352791ace071aa9efb"
    sha256 arm64_monterey: "493b6f656c1879ce82b4b6006989b6d25f6e89a83a07e9bf4fce16c10a7053ec"
    sha256 arm64_big_sur:  "253f067b184b039930d89d4eeb1d7c33a04c996bc5ed78ed3a9fa2dff44689ac"
    sha256 ventura:        "ea1a3e16dc4744e9c556a197aaae37fba6474f0b2457b457c730b39c3e249c9a"
    sha256 monterey:       "3262217ab7143ae9178ab962da8053727548395af5fc396ed59980b46f035c21"
    sha256 big_sur:        "c4c3242d0beb155dc49052f92ec5f2eac06df24850551a61ec5853b2361bee0f"
    sha256 x86_64_linux:   "e646798f0873af6ea7dbad0a89a5020c0693a0d9e6fe43a314fcdc32be73f77b"
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
