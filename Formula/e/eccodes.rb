class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://confluence.ecmwf.int/download/attachments/45757960/eccodes-2.42.0-Source.tar.gz"
  sha256 "60371b357cb011dee546db2eabace5b7e27f0f87d3ea4a5adde7891371b3c128"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/ECC/Releases"
    regex(/href=.*?eccodes[._-]v?(\d+(?:\.\d+)+)-Source\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "ddc7e963ecbaad2ad1d16ebcfc2e07fc4df6c6f5b220173d1e6b1f4e8303a69f"
    sha256 arm64_sonoma:  "dd654c5d52a1afa9bde14178107c8357114820ba5bdcdbad7be1d987d5accd64"
    sha256 arm64_ventura: "c8ff7006a5beda3641bd1326e488e22877d50abb0e300a5af801fcdc806b5041"
    sha256 sonoma:        "e16b327e548c565d4d8906224b2c818a45e1516562a1dfb9a4b411aa256ec8df"
    sha256 ventura:       "47ea7a0cdc51dc3da09a76b4ea0b4e8e6eeb533e13402a15032442137d383bba"
    sha256 arm64_linux:   "fd83a0e4bd71bb0d76240fa7d420ddc3f67bb05054da9c6eb31c5d402fc23d9b"
    sha256 x86_64_linux:  "31365acb6e216a1dc8344a6bc8d6c4949fbb988559dac4f10110c8b5c387192d"
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
