class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://confluence.ecmwf.int/download/attachments/45757960/eccodes-2.47.0-Source.tar.gz"
  sha256 "82da819aa9b51831dc14b3bf2918bfee50b1cd53a05088d0c3f4493758aae094"
  license "Apache-2.0"
  compatibility_version 1

  livecheck do
    url "https://confluence.ecmwf.int/display/ECC/Releases"
    regex(/href=.*?eccodes[._-]v?(\d+(?:\.\d+)+)-Source\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "4b82842b6f8d35429c40cb7e6c5ea115cc4f1015f689bba3a3fcb2c89884f2a5"
    sha256 arm64_sequoia: "bd91ad07992ee78024234cf8b5642135df1b46b53c7289a2c693fad8fe345989"
    sha256 arm64_sonoma:  "3c52fc89659a643249d110fc4d4acb555519990b65a4933d4175d095f8269dd0"
    sha256 sonoma:        "5402c9a00e26b14edc9382679c57626c923bb5369125de1c309cdbb477712c72"
    sha256 arm64_linux:   "41196f8f832b211cac40c99a2023102fc0a0e01abe5585bc81ee0eefe53a1746"
    sha256 x86_64_linux:  "5be92c82849fe6a5453352b24b2dc3374c840a0732fcb76d94e4dc5a1325abc1"
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
