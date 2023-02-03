class JpegXl < Formula
  desc "New file format for still image compression"
  homepage "https://jpeg.org/jpegxl/index.html"
  url "https://github.com/libjxl/libjxl/archive/v0.8.1.tar.gz"
  sha256 "60f43921ad3209c9e180563025eda0c0f9b1afac51a2927b9ff59fff3950dc56"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ed917915e08fac5108f4682a4351d046a844a7729355b45452f7abe011152471"
    sha256 cellar: :any,                 arm64_monterey: "164305ccff8619c4bd29b438a203219a9f86c4325db5e81dc1829ed2d3ae8c3f"
    sha256 cellar: :any,                 arm64_big_sur:  "f0f6bb989089e2825316260b9cdcdc9894328b2a98a334f6ad069b8f93438f1a"
    sha256 cellar: :any,                 ventura:        "566735feb5cf0ab6f53ae3e8ce88fc71951318ba497ea0b1b611e2b92d2bccc7"
    sha256 cellar: :any,                 monterey:       "051508b719eabbeaf079ae17366442d1ff4cb93799e706b681b9cde76ccac879"
    sha256 cellar: :any,                 big_sur:        "cc8cd901e436533c8d7d76548076ddd62e4ed09db7d668012d31abfb217f0679"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52d92785a2b8803557090e942c4751b245f989732296cb097c1b596e4685db05"
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
