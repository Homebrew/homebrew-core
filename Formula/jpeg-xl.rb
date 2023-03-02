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
    sha256 cellar: :any,                 arm64_ventura:  "09c59266fd1ae62615a71512597b4325c6e8cce2268efd2f56dd17bd6fb49724"
    sha256 cellar: :any,                 arm64_monterey: "f0fcfea7ac4b1c74b19742cba995cc8e94b2556125c6038ad4e469c65f8716d6"
    sha256 cellar: :any,                 arm64_big_sur:  "43207ed935381a19aa87ddf35ddfee7f0db29bddaea0707fa02da9627a1e9bfc"
    sha256 cellar: :any,                 ventura:        "d1c3e4e4deb2bc363b4365034571b6f6fc876d3d2c99e423b94585c40dbf4ae1"
    sha256 cellar: :any,                 monterey:       "38a0fe93650936ad5076820e9bfa3471584937be31b2262c9e06a1ba341019ec"
    sha256 cellar: :any,                 big_sur:        "508ad71458b58f2464fc05419ebd64b7a93a58656d933c019b6472941c144f3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41362a352dd6f980d07845337dd51bfc1e4aabd90101129c544406f65ba41e0b"
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
