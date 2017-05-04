class GribApi < Formula
  desc "Encode and decode grib messages (editions 1 and 2)"
  homepage "https://software.ecmwf.int/wiki/display/GRIB/Home"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/g/grib-api/grib-api_1.19.0.orig.tar.xz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/g/grib-api/grib-api_1.19.0.orig.tar.xz"
  sha256 "c234a0a6d551a79ac77eae86b5effaa82c96dfc16ba6a8e7570067d83f1f6326"
  revision 1

  bottle do
    sha256 "0f8223d6a5d6896171940bfdb331f56b5247dd73cff69e6d1ed54c2e4b0a2d03" => :sierra
    sha256 "263b65c97059e883da47a1f1964500f3ba289fbb3d2597f7822b8f919d648e03" => :el_capitan
    sha256 "6fb2acd370359d14f5bdaa6340e10d0987057b0fcba55bc9e1a3c73ed1d280f2" => :yosemite
  end

  option "with-static", "Build static instead of shared library."

  depends_on "cmake" => :build
  depends_on "jasper" => :recommended
  depends_on "libpng" => :optional
  depends_on :fortran

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/16/f5/b432f028134dd30cfbf6f21b8264a9938e5e0f75204e72453af08d67eb0b/numpy-1.11.2.tar.gz"
    sha256 "04db2fbd64e2e7c68e740b14402b25af51418fc43a59d9e54172b38b906b0f69"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resource("numpy").stage do
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end

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

      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    grib_samples_path = shell_output("#{bin}/grib_info -t").strip
    system bin/"grib_ls", "#{grib_samples_path}/GRIB1.tmpl"
    system bin/"grib_ls", "#{grib_samples_path}/GRIB2.tmpl"
  end
end
