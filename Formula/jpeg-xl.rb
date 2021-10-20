class JpegXl < Formula
  desc "New file format for still image compression"
  homepage "https://jpeg.org/jpegxl/index.html"
  url "https://gitlab.com/wg1/jpeg-xl/-/archive/v0.5/jpeg-xl-v0.5.tar.bz2"
  sha256 "43ae213b9ff28f672beb4f50dbee0834be2afe0015a62bf525d35ee2e7e89d6c"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_big_sur: "37a9eb58bb2e1d55f9691161544bdcd6c615787204f7426436087af5037749f8"
    sha256 cellar: :any, big_sur:       "017bbfa9af1adf69981c1ff8a7f18f3c7b4c8ac1de87168e9f4610825dcfe861"
    sha256 cellar: :any, catalina:      "b3e21b0631fca6edf8e534f1bdc23a017e766b9dd63afc87e7c16962da5f334c"
    sha256 cellar: :any, mojave:        "b7e4f3c64f8fe63c0ed2771f8e94ab69c58a3bbc9e716cfda6278682a51b450c"
  end

  depends_on "asciidoc" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "brotli"
  depends_on "giflib"
  depends_on "imath"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "openexr"
  depends_on "webp"

  # These resources are versioned according to the script supplied with jpeg-xl to download the dependencies:
  # https://gitlab.com/wg1/jpeg-xl/-/blob/v#{version}/deps.sh
  resource "highway" do
    url "https://github.com/google/highway.git",
        revision: "e2397743fe092df68b760d358253773699a16c93"
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
    # When building man pages, a2x calls xmllint --nonet,
    # which needs this to find the schema or fails otherwise.
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

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
