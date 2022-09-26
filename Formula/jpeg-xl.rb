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
    sha256 cellar: :any,                 arm64_monterey: "531986bae4962e979dd69370191739a6c81f1dea5511ec7f6f2bddf954183fa6"
    sha256 cellar: :any,                 arm64_big_sur:  "ac7eda555668e8d10b4ee5a343c0be83c907f2f551fbc2eb1ff79758242622af"
    sha256 cellar: :any,                 monterey:       "2c64701aa9d7a73dd11773a664b88f7350c60fba5ca78e4dfbc8e1f396947946"
    sha256 cellar: :any,                 big_sur:        "1c998fe7ee45716653e960a13cb82a549c4bacaa2ea3ebd43350d1dc2136ccde"
    sha256 cellar: :any,                 catalina:       "b6d8d68b7caf5216933569bc758488a65efc1de68fb980a9058fc00d475788ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14eacbeb9a01cbb812809d609eef94f3cee4a7ebeca152f59cdc0d4fcee240f9"
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
