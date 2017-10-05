class GribApi < Formula
  desc "Encode and decode grib messages (editions 1 and 2)"
  homepage "https://software.ecmwf.int/wiki/display/GRIB/Home"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/g/grib-api/grib-api_1.24.0.orig.tar.xz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/g/grib-api/grib-api_1.24.0.orig.tar.xz"
  sha256 "304206c363ee388098d01778b5514edc626ced72b9fbb07d716d4f7210ee7579"

  bottle do
    sha256 "bceb83137b03aedf80e37d98da9829f5ed719fdd1c48a3344e2bea3a1fa7a35c" => :high_sierra
    sha256 "6eb7c05946db59782de2e1de07bad94c40d48d316205b600cfb531d5e2d9b51b" => :sierra
    sha256 "9d814bcdf72889206362c31ba50257488c150007602891da924c9a31c97cd8e0" => :el_capitan
    sha256 "b4a2345386c804f28c08a2a539d0c106a70a5192c0a3fe08d1c2e278880d814b" => :yosemite
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
