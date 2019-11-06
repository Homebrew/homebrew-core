class GribApi < Formula
  desc "Encode and decode grib messages (editions 1 and 2)"
  homepage "https://software.ecmwf.int/wiki/display/GRIB/Home"
  url "https://deb.debian.org/debian/pool/main/g/grib-api/grib-api_1.28.0.orig.tar.xz"
  sha256 "6afd09feede94faf353b71caa2567b985ab214331d58e8c3f303ea01f387777d"

  bottle do
    sha256 "2e7e35349c2e2d5111af0ef8700988fb71cd97099efb750276543f61bf0b0c53" => :catalina
    sha256 "c47b2b6a977a73b010707e6190d0dde94499615913f88ef7eb4aedc4804768d0" => :mojave
    sha256 "1a0749fb9fa2f5b66ab7230920806f3dddcfb1a7b0cd3cd090e506c3f7e0e9af" => :high_sierra
    sha256 "e556a07e1d8a1ef6bd7f4c5f0c3770ffab42c897b3213d05d65e3ec9b386912b" => :sierra
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
