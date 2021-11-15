class Ccextractor < Formula
  desc "Free, GPL licensed closed caption tool"
  homepage "https://www.ccextractor.org/"
  url "https://github.com/CCExtractor/ccextractor/archive/v0.93.tar.gz"
  sha256 "0e66d3e360db1b02a88271af11313ca4c9bbda1b03728e264a44c4c9f77192e3"
  license "GPL-2.0-only"
  head "https://github.com/ccextractor/ccextractor.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2bff9205c6edf2abfc0dc1190f174e986e41163850611972b64c2feba4938a65"
    sha256 cellar: :any,                 arm64_big_sur:  "6efaaf1c5561ca5b8111ec6d5c4a218478b1ab516879eeed63c253413c29a0fd"
    sha256 cellar: :any,                 monterey:       "b222085a66cd8bf4c5dddeb77f24c79c7137eda6cc22d109aecf58cc9f07ba15"
    sha256 cellar: :any,                 big_sur:        "0a1b989824260d96acce3c9e918d931b59cd3ccebb4be4a3b076d6b7b0829d8a"
    sha256 cellar: :any,                 catalina:       "ca8aa899175221e1fe2bd7a1fb2fe5b955e130f0abf0ab9ae6d03c99732b7a3a"
    sha256 cellar: :any,                 mojave:         "196b7762b3ca019d7a99b678759a0b317e29f15cdd64e19ca7512dd6cd25a6ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ff529cb0ced01ab4a410bb3e28f51cedaec71394560fabad5f6060522090ddf"
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "gpac"
  depends_on "leptonica"
  depends_on "libpng"
  depends_on "protobuf-c"
  depends_on "tesseract"
  depends_on "utf8proc"

  resource "test.mxf" do
    url "https://raw.githubusercontent.com/alebcay/example-artifacts/5e8d84effab76c4653972ef72513fcee1d00d3c3/mxf/test.mxf"
    sha256 "e027aca08a2cce64a9fb6623a85306b5481a2f1c3f97a06fd5d3d1b45192b12a"
  end

  # Patch build script to allow building with Homebrew libs rather than upstream's bundled libs
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/9bc4ef5a88b9a4d55dead30130aa79f8eee5faf7/ccextractor/unbundle-libs.patch"
    sha256 "b610950e4ae54a8fce3f5952be6d909cb9790a9c46ff356f83e8d8255c7f1ed1"
  end

  def install
    # Multiple source files reference these dependencies with non-standard #include paths
    ENV["EXTRA_INCLUDE"] = "-I#{Formula["leptonica"].include} -I#{Formula["protobuf-c"].include/"protobuf-c"}"

    if OS.mac?
      platform = "mac"
      build_script = "./build.command"
    else
      platform = "linux"
      build_script = "./build"
    end

    cd platform do
      system build_script, "OCR"
      bin.install "ccextractor"
    end
    (pkgshare/"examples").install "docs/ccextractor.cnf.sample"
  end

  test do
    resource("test.mxf").stage do
      system bin/"ccextractor", "test.mxf", "-out=txt"
      assert_equal "This is a test video.", (Pathname.pwd/"test.txt").read.strip
    end
  end
end
