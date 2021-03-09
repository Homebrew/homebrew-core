class JpegXl < Formula
  desc "New file format for still image compression"
  homepage "https://jpeg.org/jpegxl/index.html"
  url "https://gitlab.com/wg1/jpeg-xl/-/archive/v0.3.3/jpeg-xl-v0.3.3.tar.bz2"
  sha256 "a71dd1a148212976ffe4881f395eb0de171fca2f01ed44d16002add6dc667ec2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "b60753226f78d7ef3be50e770052d8e44731d2c64b2b54e0d3f41a44300f386d"
    sha256 cellar: :any, big_sur:       "bee178acbf480d2c02ab07723d4608ecad5bc1436744e153c0b933e36ac39d1d"
    sha256 cellar: :any, catalina:      "868505cf9c4d421f2fdbd6951802b24309ded052ece4ca3e7f9c7d5ade25aa16"
    sha256 cellar: :any, mojave:        "757ab7c5228678bf2f9b93e430b60ccdf035eaca95bc7e6d20c88ebf5b1d8a3c"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "brotli"
  depends_on "giflib"
  depends_on "ilmbase"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "openexr"
  depends_on "webp"

  # These resources are versioned according to the script supplied with jpeg-xl to download the dependencies:
  # https://gitlab.com/wg1/jpeg-xl/-/blob/v#{version}/deps.sh
  resource "highway" do
    url "https://github.com/google/highway.git",
        revision: "946a1b40233438a1b0363598a6deaa1628a01003"
  end

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
    mkdir "build" do
      system "cmake", "..", "-DBUILD_TESTING=OFF", *std_cmake_args
      system "cmake", "--build", "."
      system "cmake", "--build", ".", "--target", "install"
    end
  end

  test do
    system "#{bin}/cjxl", test_fixtures("test.jpg"), "test.jxl"
    assert_predicate testpath/"test.jxl", :exist?
  end
end
