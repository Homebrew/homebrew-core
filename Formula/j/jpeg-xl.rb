class JpegXl < Formula
  desc "New file format for still image compression"
  homepage "https://jpeg.org/jpegxl/index.html"
  url "https://github.com/libjxl/libjxl/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "24d18c9af2d1f5a17730b3f8d3f70a5c16e5ac303f5d9d5fe9dc00cf7ca82af2"
  license "BSD-3-Clause"
  compatibility_version 3

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f5613d8fd10ef72372c1fe2b14ccb51fa332f4119f916deabb9fa07b8a1f3f3a"
    sha256 cellar: :any, arm64_tahoe:       "1da12f614c4db97c3afa09d7dec5b9e719dca06bb1a3f545358ff38ce6dbb33b"
    sha256 cellar: :any, arm64_sequoia:     "3c193d49dacde5e78331ff37462b5ef7f09d44279801ad2df911a7a5d618c109"
    sha256 cellar: :any, arm64_linux:       "164c7ce15a5764ec30fc41ccb62229e9f88896e5c05f0391a67a225e8fc1a92a"
    sha256 cellar: :any, x86_64_linux:      "10819cf13cf5b5fcc5c8170c5c857fd6903dfcc02f328899c76f69ddd4ee8fbe"
  end

  depends_on "asciidoc" => :build
  depends_on "cmake" => :build
  depends_on "docbook-xsl" => :build
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
    url "https://github.com/webmproject/sjpeg/archive/dd4d9857c58a25713711a46d37385ad23ca2177e.tar.gz"
    version "dd4d9857c58a25713711a46d37385ad23ca2177e"
    sha256 "94ee1d632b32ed9a1487afde078705fdf5772e8f1f54d80e7cb283b8f0ef8a95"

    livecheck do
      url "https://raw.githubusercontent.com/libjxl/libjxl/refs/tags/v#{LATEST_VERSION}/deps.sh"
      regex(/THIRD_PARTY_SJPEG="(\h+)"/i)
    end
  end

  deny_network_access!

  def install
    ENV.append_path "XML_CATALOG_FILES", etc/"xml/catalog"
    resources.each { |r| r.stage buildpath/"third_party"/r.name }
    system "cmake", "-S", ".", "-B", "build",
                    "-DJPEGXL_FORCE_SYSTEM_BROTLI=ON",
                    "-DJPEGXL_FORCE_SYSTEM_LCMS2=ON",
                    "-DJPEGXL_FORCE_SYSTEM_HWY=ON",
                    "-DJPEGXL_ENABLE_DEVTOOLS=ON",
                    "-DJPEGXL_ENABLE_DOXYGEN=OFF",
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
