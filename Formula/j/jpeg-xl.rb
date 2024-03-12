class JpegXl < Formula
  desc "New file format for still image compression"
  homepage "https://jpeg.org/jpegxl/index.html"
  url "https://github.com/libjxl/libjxl/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "95e807f63143856dc4d161c071cca01115d2c6405b3d3209854ac6989dc6bb91"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7624f860e59e279c5810bb7c2baa1a1a70beae2166f1781b00ce32ea3c949860"
    sha256 cellar: :any,                 arm64_ventura:  "136444e6e6c21514af90cd1b4abdaa95a9559b3996fe4710deba5edb825af2cf"
    sha256 cellar: :any,                 arm64_monterey: "4fefef455164e3c000c11fb55579c5b43983666d4898dec23dce4f4964a3433a"
    sha256 cellar: :any,                 sonoma:         "90c89d7f44a6a3cdb6f369d23fe2c7d6a2a013ed14acfe65c8637586aad721d9"
    sha256 cellar: :any,                 ventura:        "a00279e231490fa6419f3fb17f1c5933fa470e92cb15c5a13f405d9e03f63527"
    sha256 cellar: :any,                 monterey:       "f9012616b6d6d773dd97f21f9f1306027e49d9a2165ff5c0670b845e58292bfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c6a70e3be41ab8b953baf0bbc9eac8c4be9b5d4caaea58b916fa569fd3805c2"
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
  uses_from_macos "python"

  fails_with gcc: "5"
  fails_with gcc: "6"

  # These resources are versioned according to the script supplied with jpeg-xl to download the dependencies:
  # https://github.com/libjxl/libjxl/tree/v#{version}/third_party
  resource "sjpeg" do
    url "https://github.com/webmproject/sjpeg.git",
        revision: "e5ab13008bb214deb66d5f3e17ca2f8dbff150bf"
  end

  def install
    ENV.append_path "XML_CATALOG_FILES", HOMEBREW_PREFIX/"etc/xml/catalog"
    resources.each { |r| r.stage buildpath/"third_party"/r.name }
    system "cmake", "-S", ".", "-B", "build",
                    "-DJPEGXL_FORCE_SYSTEM_BROTLI=ON",
                    "-DJPEGXL_FORCE_SYSTEM_LCMS2=ON",
                    "-DJPEGXL_FORCE_SYSTEM_HWY=ON",
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
