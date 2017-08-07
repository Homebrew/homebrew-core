class GribApi < Formula
  desc "Encode and decode grib messages (editions 1 and 2)"
  homepage "https://software.ecmwf.int/wiki/display/GRIB/Home"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/g/grib-api/grib-api_1.23.0.orig.tar.xz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/g/grib-api/grib-api_1.23.0.orig.tar.xz"
  sha256 "eeb908248f974daa8cc6224325c9938aca63f99b4e3c9366f4c34e3d179e2772"

  bottle do
    sha256 "6a405004526ab9d97fe7d26bd3ab9b08badfb8a77e09ce87a7a10872a606014c" => :sierra
    sha256 "5468ebc85476730b762c46e74cff226c1447e19ae435205fcb0227769beb0921" => :el_capitan
    sha256 "5d8349c159e1ad3edd0f354e340204262e654049105fc69ba7fc72421a8898ed" => :yosemite
  end

  option "with-static", "Build static instead of shared library."

  depends_on "cmake" => :build
  depends_on "numpy"
  depends_on "jasper" => :recommended
  depends_on "libpng" => :optional
  depends_on :fortran

  def install
    # Fix "no member named 'inmem_' in 'jas_image_t'"
    inreplace "src/grib_jasper_encoding.c", "image.inmem_    = 1;", ""

    inreplace "CMakeLists.txt", "find_package( OpenJPEG )", ""

    mkdir "build" do
      args = std_cmake_args
      args << "-DBUILD_SHARED_LIBS=OFF" if build.with? "static"

      if build.with? "libpng"
        args << "-DPNG_PNG_INCLUDE_DIR=#{Formula["libpng"].opt_include}"
        args << "-DENABLE_PNG=ON"
      end

      system "cmake", "..", "-DENABLE_NETCDF=OFF", *args
      system "make", "install"
    end
  end

  test do
    grib_samples_path = shell_output("#{bin}/grib_info -t").strip
    system bin/"grib_ls", "#{grib_samples_path}/GRIB1.tmpl"
    system bin/"grib_ls", "#{grib_samples_path}/GRIB2.tmpl"
  end
end
