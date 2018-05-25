class GribApi < Formula
  desc "Encode and decode grib messages (editions 1 and 2)"
  homepage "https://software.ecmwf.int/wiki/display/GRIB/Home"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/g/grib-api/grib-api_1.26.1.orig.tar.xz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/g/grib-api/grib-api_1.26.1.orig.tar.xz"
  sha256 "ee4a4607f7208ee329d9ae622dc34da8f0675ac08ab65ebe61c68856bebee810"
  revision 1

  bottle do
    sha256 "81aca09548a227262929f5f023c3003afd339e2e925da5c298b491ec63060cf7" => :high_sierra
    sha256 "005a1386fda8d4657977ad77081c2d57bd651f4e3ccab03f905a1b43f77180b2" => :sierra
    sha256 "99591a2967dd1467c872471234996336025280ef53b96587e50eee01de221b39" => :el_capitan
  end

  option "with-static", "Build static instead of shared library."

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "numpy"
  depends_on "jasper" => :recommended
  depends_on "libpng" => :optional

  conflicts_with "eccodes",
    :because => "grib-api and eccodes install the same binaries."

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
