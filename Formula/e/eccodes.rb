class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://confluence.ecmwf.int/download/attachments/45757960/eccodes-2.40.0-Source.tar.gz"
  sha256 "f58d5d7390fce86c62b26d76b9bc3c4d7d9a6cf2e5f8145d1d598089195e51ff"
  license "Apache-2.0"
  revision 1

  livecheck do
    url "https://confluence.ecmwf.int/display/ECC/Releases"
    regex(/href=.*?eccodes[._-]v?(\d+(?:\.\d+)+)-Source\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "0643fe3aa66edf998b80f393ab200934d2b055c3eb497da46458d8aaba7860ab"
    sha256 arm64_sonoma:  "e5586c52a0f8d08201f0d83f9f7d3a6df4d707512c2f2bfdbff5138e7847e02b"
    sha256 arm64_ventura: "d119abb244cf287d71c062655d2833c82b717575a14cec8c72c927c4202ee39f"
    sha256 sonoma:        "f9113e5a8427be24b469da5794ad46f67143fc127c2255b2c96f972d52a90faa"
    sha256 ventura:       "bda65f7d3788109e09e48ac2f7c704c105a0c3d83f2682db4e3637cbb9272dd1"
    sha256 x86_64_linux:  "9fb1affd973a32a59c3472384e611e36ff51b9b2d32d0243ab0dab35ab4c1c4a"
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
