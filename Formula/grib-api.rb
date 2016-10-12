class GribApi < Formula
  desc "Encode and decode grib messages (editions 1 and 2)"
  homepage "https://software.ecmwf.int/wiki/display/GRIB/Home"
  url "https://software.ecmwf.int/wiki/download/attachments/3473437/grib_api-1.18.0-Source.tar.gz"
  sha256 "dfffeeb4df715b234907cb12d6729617bed0df0ff023337c2dd3cd20ab58199e"

  bottle do
    sha256 "0426ca81bf84c562373f5a3359276724d9b06a3c021412b3f3cd1a7df7a08496" => :sierra
    sha256 "8385d6d75a6b8a0c727d227990a4f30425242b07926111eb47306b4edb792b75" => :el_capitan
    sha256 "6b9c42c18630c12889ebcf112b77d145e4126d20e64416746cecd66db395d5ec" => :yosemite
    sha256 "eceae2f4b4841aa46e55b85750aad88b81efb44c1be5aa25736f799dd8f8d6be" => :mavericks
  end

  option "with-static", "Build static instead of shared library."

  depends_on "cmake" => :build
  depends_on "jasper" => :recommended
  depends_on "libpng" => :optional
  depends_on :fortran

  def install
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
