class GribApi < Formula
  desc "Encode and decode grib messages (editions 1 and 2)"
  homepage "https://software.ecmwf.int/wiki/display/GRIB/Home"
  url "https://software.ecmwf.int/wiki/download/attachments/3473437/grib_api-1.18.0-Source.tar.gz"
  mirror "https://distfiles.macports.org/grib_api/grib_api-1.18.0-Source.tar.gz"
  sha256 "dfffeeb4df715b234907cb12d6729617bed0df0ff023337c2dd3cd20ab58199e"
  revision 1

  bottle do
    sha256 "1add34660d71a4f1a32837b6270245d39d459ad8ac06fa85ed8d199ee3b857f9" => :sierra
    sha256 "890a36a4df3ecb00bba7d73297d338381a9ccd1cecdf390f76aa66ea00ab9ffb" => :el_capitan
    sha256 "4392fd87478b5f1f0336c230a31e9427f19aefa2ba91152be536e9c8d3f1bbef" => :yosemite
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
