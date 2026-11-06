class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://confluence.ecmwf.int/download/attachments/45757960/eccodes-2.50.1-Source.tar.gz"
  sha256 "cba10e2221d5faea9da0d674c5bcc98493badce42fbf336cd7d9bb3424a6ce29"
  license "Apache-2.0"
  compatibility_version 1

  livecheck do
    url "https://confluence.ecmwf.int/display/ECC/Releases"
    regex(/href=.*?eccodes[._-]v?(\d+(?:\.\d+)+)-Source\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "5cd69792a53268294267d13b100692719cbe1862bcda547cbc12aa716e10ddab"
    sha256 arm64_tahoe:       "12071e38cbb3f5b18e55ffb2a1acdfdd2aa6d2ed02bda53e296f5af3f9a7c39d"
    sha256 arm64_sequoia:     "079496809e7fef3b7b1075e7d53ce2d6b9125941715ffc1ebaf1fef03b0a826a"
    sha256 arm64_linux:       "b3c14f13758d0b50d72f087c7ff7b1befe6aa71e5d2a42043ebb2596ebc9afc8"
    sha256 x86_64_linux:      "11c4970a5aa635e8e88f8c63fb4ab38c5e49f115d48f58e5bc45bded99bee622"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "libaec"
  depends_on "libpng"
  depends_on "netcdf"
  depends_on "openjpeg"

  deny_network_access!

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
