class JpegXl < Formula
  desc "New file format for still image compression"
  homepage "https://jpeg.org/jpegxl/index.html"
  url "https://github.com/libjxl/libjxl/archive/v0.8.1.tar.gz"
  sha256 "60f43921ad3209c9e180563025eda0c0f9b1afac51a2927b9ff59fff3950dc56"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7f91c90c84cc6d9a48a046bd1e1b287c501ad204bbf1aa85d0fb9de4d4c81fb8"
    sha256 cellar: :any,                 arm64_monterey: "49d3e3c20e9d1465da66708198a04acde9a63a655769d85025f953b01504ff25"
    sha256 cellar: :any,                 arm64_big_sur:  "cc73c732b088a6c22cde87f4928af39185e518ed7d29478b090bb848ef988a44"
    sha256 cellar: :any,                 ventura:        "f3067f81764ce03946122d59197100da9aa2a41337a430bc622b3dd2c44bacff"
    sha256 cellar: :any,                 monterey:       "acc6338a4fa91a43933b23e8884e0c8ff3a4b915834d15f9cc19d87bea7aaff8"
    sha256 cellar: :any,                 big_sur:        "b03b751c9e71d937f5f1b0c3460829197a4866b9d79a2bd6858ab0d225fa4744"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f96867e2e15962f29f8be41c54395d3cf29c59db3cce89a839704d605bdf0ae"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
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

  fails_with gcc: "5"
  fails_with gcc: "6"

  # These resources are versioned according to the script supplied with jpeg-xl to download the dependencies:
  # https://github.com/libjxl/libjxl/tree/v#{version}/third_party
  resource "sjpeg" do
    url "https://github.com/webmproject/sjpeg.git",
        revision: "868ab558fad70fcbe8863ba4e85179eeb81cc840"
  end

  resource "skcms" do
    url "https://skia.googlesource.com/skcms.git",
        revision: "b25b07b4b07990811de121c0356155b2ba0f4318"
  end

  def install
    resources.each { |r| r.stage buildpath/"third_party"/r.name }
    # disable manpages due to problems with asciidoc 10
    system "cmake", "-S", ".", "-B", "build",
                    "-DJPEGXL_FORCE_SYSTEM_BROTLI=ON",
                    "-DJPEGXL_FORCE_SYSTEM_LCMS2=ON",
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
