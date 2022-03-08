class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://confluence.ecmwf.int/download/attachments/45757960/eccodes-2.24.2-Source.tar.gz"
  sha256 "c60ad0fd89e11918ace0d84c01489f21222b11d6cad3ff7495856a0add610403"
  license "Apache-2.0"
  revision 1

  livecheck do
    url "https://confluence.ecmwf.int/display/ECC/Releases"
    regex(/href=.*?eccodes[._-]v?(\d+(?:\.\d+)+)-Source\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "6abee056fdfa33f607b1d58de965ecfeb142be352f48c8019414b22f76369a8d"
    sha256 arm64_big_sur:  "e6220a587aecab527351ce744e4c96055d381ee95f925b28a5b191ac5e7208e4"
    sha256 monterey:       "f3b3d850a8cff1b51656b069b1bf8b13d5677b959ddef3056bc09d7f33ff6ac0"
    sha256 big_sur:        "aca9899c0da2a308c86f1d64ff5304e22babd14db02c310d4d0c9dc1e72ba5b5"
    sha256 catalina:       "68452564bd5f92bb96e4bbb3bd89f6acdaeed5c3aeaf0adbe78ff01fc03f5d66"
    sha256 x86_64_linux:   "ec7c1bde10e5fdd2416e56b6f73d78ce015a5f3a8cbc5162d07005cb9c623776"
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
