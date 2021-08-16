class Ccextractor < Formula
  desc "Free, GPL licensed closed caption tool"
  homepage "https://www.ccextractor.org/"
  url "https://github.com/CCExtractor/ccextractor/archive/v0.92.tar.gz"
  sha256 "7e20c14c265b2753bb052487d6fbff980391ed35f6fca9ece256dce30b6b81fa"
  license "GPL-2.0-only"
  head "https://github.com/ccextractor/ccextractor.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "bd599ecf453dd421f76acc2b74fb3ed5e77bed2cabe012a4d0e5dece89b3e645"
    sha256 cellar: :any,                 big_sur:       "7ef74d19888cc643e9cccc6be88123b354bddc60d79ff1597e2db15d0fd053a8"
    sha256 cellar: :any,                 catalina:      "ebb303622c9d44a67532afe590ec0fcad987cd602f5903a1b193cd86aebcf140"
    sha256 cellar: :any,                 mojave:        "14a4e53589bae04b5acfea0e5c95528d0a9196393c40dbe020beea7ae359d537"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5988d41b84e97724ecab3eaad7cb1a28c6f425a410bcc43ab44a0ee21591d301"
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

    platform = "mac"
    build_script = "./build.command"

    on_linux do
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
