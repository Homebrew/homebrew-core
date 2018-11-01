class GribApi < Formula
  desc "Encode and decode grib messages (editions 1 and 2)"
  homepage "https://software.ecmwf.int/wiki/display/GRIB/Home"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/g/grib-api/grib-api_1.27.0.orig.tar.xz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/g/grib-api/grib-api_1.27.0.orig.tar.xz"
  sha256 "81078fb9946c38cd292c4eaa50f0acf0093f709a247e83493b3181955177ba09"
  revision 1

  bottle do
    sha256 "cd972852461b2d0fd723e47bcef574a6701f71177d1aaa5f7b66844c9f86b602" => :mojave
    sha256 "158fccf39188a5abd7281866f1d89f8c91c2b0885d85e92d207dfa40678d57c9" => :high_sierra
    sha256 "79a6e75196027e6d8310f12dac756776ed8f422268aa0623b6f28b400feeba93" => :sierra
    sha256 "923b9062ff3f34b4517c52def1831b0bd0b4debd555f12655fdf6776be965521" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "jasper"
  depends_on "libpng"
  depends_on "numpy"

  conflicts_with "eccodes",
    :because => "grib-api and eccodes install the same binaries."

  def install
    # Fix "no member named 'inmem_' in 'jas_image_t'"
    inreplace "src/grib_jasper_encoding.c", "image.inmem_    = 1;", ""

    inreplace "CMakeLists.txt", "find_package( OpenJPEG )", ""

    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DENABLE_NETCDF=OFF",
                            "-DENABLE_PNG=ON",
                            "-DPNG_PNG_INCLUDE_DIR=#{Formula["libpng"].opt_include}"
      system "make", "install"
    end
  end

  test do
    grib_samples_path = shell_output("#{bin}/grib_info -t").strip
    system bin/"grib_ls", "#{grib_samples_path}/GRIB1.tmpl"
    system bin/"grib_ls", "#{grib_samples_path}/GRIB2.tmpl"
  end
end
