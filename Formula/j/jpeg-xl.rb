class JpegXl < Formula
  desc "New file format for still image compression"
  homepage "https://jpeg.org/jpegxl/index.html"
  url "https://github.com/libjxl/libjxl/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "ab38928f7f6248e2a98cc184956021acb927b16a0dee71b4d260dc040a4320ea"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "964f9e0ed13c844e1fb2675008a6b0dfe247dce7765951052031c67f6ffd39de"
    sha256 cellar: :any,                 arm64_sequoia: "2236d40860aec925d6147e5b4f1a962d3a4d664e77aa7eb34773fe4fca70917f"
    sha256 cellar: :any,                 arm64_sonoma:  "3c55d4e64f4287188f3289178528f67573d2df7b12f6f78732cb35df13c09bc2"
    sha256 cellar: :any,                 sonoma:        "8e44a6091c85772b58897b35ff3a3ab2f4b0441c53f5b0051baa5a45dca058be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d92c9a8b9c80a3c3d9a0ecf042510f867913df111846cfff843f77ee6719cb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "529152dc60c01bd380e99aa66798857db83932ddb45cfd908447ec1e7fe8d1fb"
  end

  depends_on "asciidoc" => :build
  depends_on "cmake" => :build
  depends_on "docbook-xsl" => :build
  depends_on "doxygen" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "sphinx-doc" => :build
  depends_on "webp" => :build
  depends_on "brotli"
  depends_on "giflib"
  depends_on "highway"
  depends_on "imath"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "little-cms2"
  depends_on "openexr"

  uses_from_macos "libxml2" => :build
  uses_from_macos "libxslt" => :build # for xsltproc

  # These resources are versioned according to the script supplied with jpeg-xl to download the dependencies:
  # https://github.com/libjxl/libjxl/tree/v#{version}/third_party
  resource "sjpeg" do
    url "https://github.com/webmproject/sjpeg/archive/94e0df6d0f8b44228de5be0ff35efb9f946a13c9.tar.gz"
    sha256 "ac94917fe745a674eabf1e044f23ec55cd5a548c9869c06ec4b19da14ee0227d"
  end

  def install
    ENV.append_path "XML_CATALOG_FILES", etc/"xml/catalog"
    resources.each { |r| r.stage buildpath/"third_party"/r.name }
    system "cmake", "-S", ".", "-B", "build",
                    "-DJPEGXL_FORCE_SYSTEM_BROTLI=ON",
                    "-DJPEGXL_FORCE_SYSTEM_LCMS2=ON",
                    "-DJPEGXL_FORCE_SYSTEM_HWY=ON",
                    "-DJPEGXL_ENABLE_DEVTOOLS=ON",
                    "-DJPEGXL_ENABLE_MANPAGES=ON",
                    "-DJPEGXL_ENABLE_JNI=OFF",
                    "-DJPEGXL_ENABLE_JPEGLI=OFF",
                    "-DJPEGXL_ENABLE_SKCMS=OFF",
                    "-DJPEGXL_VERSION=#{version}",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

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
