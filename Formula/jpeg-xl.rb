class JpegXl < Formula
  desc "New file format for still image compression"
  homepage "https://jpeg.org/jpegxl/index.html"
  url "https://gitlab.com/wg1/jpeg-xl/-/archive/v0.3.7/jpeg-xl-v0.3.7.tar.bz2"
  sha256 "32548f17c2a596e9963aa09934710f96dca6f78ec2337d7936dada89a6090b56"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "8fff72ca3de9e74b7ca942aac9e84bcae308f64c055e121517f2a277bfb45966"
    sha256 cellar: :any, big_sur:       "1a366d8660df544302d59f7a250d5af4bf4dd1b43a40235fb87b40d0c49fcfea"
    sha256 cellar: :any, catalina:      "02dffd294c06f757ff5610c4f16f7de7c6879a289a5bdb4302abb1c9fe618c67"
    sha256 cellar: :any, mojave:        "7edf2e01206b608db978f61b44ca26b5f2a70fda0e0244cc56e3835c24465497"
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
