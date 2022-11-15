class JpegXl < Formula
  desc "New file format for still image compression"
  homepage "https://jpeg.org/jpegxl/index.html"
  url "https://github.com/libjxl/libjxl/archive/v0.7.0.tar.gz"
  sha256 "3114bba1fabb36f6f4adc2632717209aa6f84077bc4e93b420e0d63fa0455c5e"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7eb0830be36d3318ebcc215ac69cdd63e7f99fd0792e990112c5b26a90afd816"
    sha256 cellar: :any,                 arm64_monterey: "61c94c8298518c28e7691f81a2121ce486d858dedadfe60022e1e551511030fc"
    sha256 cellar: :any,                 arm64_big_sur:  "371a558450a0fdfdd8de9989011f1001a4e04e32e437f596299caee66c0ba18c"
    sha256 cellar: :any,                 ventura:        "09a8f21c88586da121b247e5b52233009f85dba0434c63deb470aaf558de487b"
    sha256 cellar: :any,                 monterey:       "a9f204cf962676a52a330a71d217c83c14e40a756f02edfdd8d5d8aedfb14663"
    sha256 cellar: :any,                 big_sur:        "012d7b28ece1cfcd64bd2c26b35f19143dc606ba76bcd0e5eac667d6a3173f14"
    sha256 cellar: :any,                 catalina:       "0ee7f2e5766b3cea61538f03925f22b6fba782f1c40e4db6439b07f7ec84ec1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba13a60f0f71f0818f95cc17f2dccdcf9062735b7a5aa98412fbcb6ca8e96ce9"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "brotli"
  depends_on "giflib"
  depends_on "highway"
  depends_on "imath"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "openexr"
  depends_on "webp"

  uses_from_macos "libxml2" => :build
  uses_from_macos "libxslt" => :build # for xsltproc

  fails_with gcc: "5"
  fails_with gcc: "6"

  # These resources are versioned according to the script supplied with jpeg-xl to download the dependencies:
  # https://github.com/libjxl/libjxl/tree/v#{version}/third_party
  resource "lodepng" do
    url "https://github.com/lvandeve/lodepng.git",
        revision: "48e5364ef48ec2408f44c727657ac1b6703185f8"
  end

  resource "sjpeg" do
    url "https://github.com/webmproject/sjpeg.git",
        revision: "868ab558fad70fcbe8863ba4e85179eeb81cc840"
  end

  resource "skcms" do
    url "https://skia.googlesource.com/skcms.git",
        revision: "64374756e03700d649f897dbd98c95e78c30c7da"
  end

  def install
    resources.each { |r| r.stage buildpath/"third_party"/r.name }
    # disable manpages due to problems with asciidoc 10
    system "cmake", "-S", ".", "-B", "build",
                    "-DJPEGXL_FORCE_SYSTEM_BROTLI=ON",
                    "-DJPEGXL_FORCE_SYSTEM_HWY=ON",
                    "-DJPEGXL_ENABLE_JNI=OFF",
                    "-DJPEGXL_VERSION=#{version}",
                    "-DJPEGXL_ENABLE_MANPAGES=OFF",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--build", "build", "--target", "install"
  end

  test do
    system "#{bin}/cjxl", test_fixtures("test.jpg"), "test.jxl"
    assert_predicate testpath/"test.jxl", :exist?
  end
end
