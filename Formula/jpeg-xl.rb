class JpegXl < Formula
  desc "New file format for still image compression"
  homepage "https://jpeg.org/jpegxl/index.html"
  url "https://github.com/libjxl/libjxl/archive/v0.8.1.tar.gz"
  sha256 "60f43921ad3209c9e180563025eda0c0f9b1afac51a2927b9ff59fff3950dc56"
  license "BSD-3-Clause"
  revision 3

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a7e86ded398aee83512ec13c54d9fc86a6d9bb26a79c8cb2c6135df6ac01d43c"
    sha256 cellar: :any,                 arm64_monterey: "4c0f154ba99942127173a9354df20078a73e4492fca9304c6f29e423f9457c38"
    sha256 cellar: :any,                 arm64_big_sur:  "8482fd52f7d29ae0fc25c4aff40012e421a794d3fdb25f3dad926c19cb7c726e"
    sha256 cellar: :any,                 ventura:        "552a7e8334f2a52fc9acbc8b8ddde66d763aa2d87d71fe135219ac69348e51fd"
    sha256 cellar: :any,                 monterey:       "b2f5ed35b84e207fc751caea23415823443cdafc8b96ab9fefce551b4985e81c"
    sha256 cellar: :any,                 big_sur:        "308f4e9fb79ec9260d7220cd36eb2d07147e41d1cc110f8081ba7ae7df0e6339"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "421877325423beccd46b4ab4a6d3ef9a6a631467c13f4291bf8d35082a2c781a"
  end

  depends_on "asciidoc" => :build
  depends_on "cmake" => :build
  depends_on "docbook-xsl" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "pkg-config" => :test
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

  fails_with gcc: "5"
  fails_with gcc: "6"
  fails_with :clang do
    build 1000
    cause <<-EOS
      lib/jxl/enc_fast_lossless.cc:369:7: error: invalid cpu feature string for builtin
        if (__builtin_cpu_supports("avx512vbmi2")) {
            ^                      ~~~~~~~~~~~~~
    EOS
  end

  # These resources are versioned according to the script supplied with jpeg-xl to download the dependencies:
  # https://github.com/libjxl/libjxl/tree/v#{version}/third_party
  resource "sjpeg" do
    url "https://github.com/webmproject/sjpeg.git",
        revision: "868ab558fad70fcbe8863ba4e85179eeb81cc840"
  end

  def install
    ENV.append_path "XML_CATALOG_FILES", HOMEBREW_PREFIX/"etc/xml/catalog"
    resources.each { |r| r.stage buildpath/"third_party"/r.name }
    system "cmake", "-S", ".", "-B", "build",
                    "-DJPEGXL_FORCE_SYSTEM_BROTLI=ON",
                    "-DJPEGXL_FORCE_SYSTEM_LCMS2=ON",
                    "-DJPEGXL_FORCE_SYSTEM_HWY=ON",
                    "-DJPEGXL_ENABLE_JNI=OFF",
                    "-DJPEGXL_ENABLE_SKCMS=OFF",
                    "-DJPEGXL_VERSION=#{version}",
                    "-DJPEGXL_ENABLE_MANPAGES=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DPython3_EXECUTABLE=#{Formula["asciidoc"].libexec/"bin/python3"}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--build", "build", "--target", "install"
  end

  test do
    system "#{bin}/cjxl", test_fixtures("test.jpg"), "test.jxl"
    assert_predicate testpath/"test.jxl", :exist?

    (testpath/"jxl_test.c").write <<~EOS
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
    EOS
    jxl_flags = shell_output("pkg-config --cflags --libs libjxl").chomp.split
    system ENV.cc, "jxl_test.c", *jxl_flags, "-o", "jxl_test"
    system "./jxl_test"

    (testpath/"jxl_threads_test.c").write <<~EOS
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
    EOS
    jxl_threads_flags = shell_output("pkg-config --cflags --libs libjxl_threads").chomp.split
    system ENV.cc, "jxl_threads_test.c", *jxl_threads_flags, "-o", "jxl_threads_test"
    system "./jxl_threads_test"
  end
end
