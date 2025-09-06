class JpegXl < Formula
  desc "New file format for still image compression"
  homepage "https://jpeg.org/jpegxl/index.html"
  url "https://github.com/libjxl/libjxl/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "1492dfef8dd6c3036446ac3b340005d92ab92f7d48ee3271b5dac1d36945d3d9"
  license "BSD-3-Clause"
  revision 3

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2e9c1ceb4114a0adcab516c4a1b6a8c0eb2483123697a302fb55995b32ee6368"
    sha256 cellar: :any,                 arm64_sonoma:  "4372e2a363b4cef1746827a3f17b8825cf54b4756af9c5768ffc9305c8e8390e"
    sha256 cellar: :any,                 arm64_ventura: "a2a31e35252bcae80171e8dc890bb8c2a7328a8228c9aafda308b6a7e2a0e095"
    sha256 cellar: :any,                 sonoma:        "feebc26329a640872f3082146e00cb6b2b43aa8b8fcb7870095c61ec96b46983"
    sha256 cellar: :any,                 ventura:       "12b7aaddc78dbc6aaa06d08fd23ea73f3b48dee5bdd4d8541cc9932939d1a42c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e85cc95cd126cff09d59ca52926f519de007551759990f53287d70e7bd6f8f89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1906ec50ffafca326cd831b67b18ff2e4bb5b2a8b8f07c05fef34beb699cf38"
  end

  depends_on "asciidoc" => :build
  depends_on "cmake" => :build
  depends_on "docbook-xsl" => :build
  depends_on "doxygen" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "sphinx-doc" => :build
  depends_on "brotli"
  depends_on "giflib"
  depends_on "highway"
  depends_on "imath"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "little-cms2"
  depends_on "openexr"
  depends_on "webp"

  uses_from_macos "libxml2" => :build
  uses_from_macos "libxslt" => :build # for xsltproc
  uses_from_macos "python"

  # These resources are versioned according to the script supplied with jpeg-xl to download the dependencies:
  # https://github.com/libjxl/libjxl/tree/v#{version}/third_party
  resource "sjpeg" do
    url "https://github.com/webmproject/sjpeg.git",
        revision: "94e0df6d0f8b44228de5be0ff35efb9f946a13c9"
  end

  def install
    ENV.append_path "XML_CATALOG_FILES", HOMEBREW_PREFIX/"etc/xml/catalog"
    resources.each { |r| r.stage buildpath/"third_party"/r.name }
    system "cmake", "-S", ".", "-B", "build",
                    "-DJPEGXL_FORCE_SYSTEM_BROTLI=ON",
                    "-DJPEGXL_FORCE_SYSTEM_LCMS2=ON",
                    "-DJPEGXL_FORCE_SYSTEM_HWY=ON",
                    "-DJPEGXL_ENABLE_DEVTOOLS=ON",
                    "-DJPEGXL_ENABLE_JNI=OFF",
                    "-DJPEGXL_ENABLE_JPEGLI=OFF",
                    "-DJPEGXL_ENABLE_SKCMS=OFF",
                    "-DJPEGXL_VERSION=#{version}",
                    "-DJPEGXL_ENABLE_MANPAGES=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DPython_EXECUTABLE=#{Formula["asciidoc"].libexec/"bin/python"}",
                    "-DPython3_EXECUTABLE=#{Formula["asciidoc"].libexec/"bin/python3"}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--build", "build", "--target", "install"

    # Avoid rebuilding dependents that hard-code the prefix.
    inreplace (lib/"pkgconfig").glob("*.pc"), prefix, opt_prefix
  end

  test do
    system bin/"cjxl", test_fixtures("test.jpg"), "test.jxl"
    assert_path_exists testpath/"test.jxl"

    (testpath/"jxl_test.c").write <<~C
      #include <jxl/encode.h>
      #include <stdlib.h>

      int main()
      {
          JxlEncoder* enc = JxlEncoderCreate(NULL);
          if (enc == NULL) {
            return EXIT_FAILURE;
          }
          JxlEncoderDestroy(enc);
          return EXIT_SUCCESS;
      }
    C
    jxl_flags = shell_output("pkgconf --cflags --libs libjxl").chomp.split
    system ENV.cc, "jxl_test.c", *jxl_flags, "-o", "jxl_test"
    system "./jxl_test"

    (testpath/"jxl_threads_test.c").write <<~C
      #include <jxl/thread_parallel_runner.h>
      #include <stdlib.h>

      int main()
      {
          void* runner = JxlThreadParallelRunnerCreate(NULL, 1);
          if (runner == NULL) {
            return EXIT_FAILURE;
          }
          JxlThreadParallelRunnerDestroy(runner);
          return EXIT_SUCCESS;
      }
    C
    jxl_threads_flags = shell_output("pkgconf --cflags --libs libjxl_threads").chomp.split
    system ENV.cc, "jxl_threads_test.c", *jxl_threads_flags, "-o", "jxl_threads_test"
    system "./jxl_threads_test"
  end
end
