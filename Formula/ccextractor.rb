class Ccextractor < Formula
  desc "Free, GPL licensed closed caption tool"
  homepage "https://www.ccextractor.org/"
  url "https://github.com/CCExtractor/ccextractor/archive/v0.94.tar.gz"
  sha256 "9c7be386257c69b5d8cd9d7466dbf20e3a45cea950cc8ca7486a956c3be54a42"
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

  resource "homebrew-test.mxf" do
    url "https://raw.githubusercontent.com/alebcay/example-artifacts/5e8d84effab76c4653972ef72513fcee1d00d3c3/mxf/test.mxf"
    sha256 "e027aca08a2cce64a9fb6623a85306b5481a2f1c3f97a06fd5d3d1b45192b12a"
  end

  # Patch build script to allow building with Homebrew libs rather than upstream's bundled libs
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/e5fddd607fb4e2b6b16044eb47fa3407d4d1fdb0/ccextractor/unbundle-libs.patch"
    sha256 "eb545afad2d1d47a22f50ec0cdad0da11e875d5119213b0e5ace36488f08d237"
  end

  def install
    # Multiple source files reference these dependencies with non-standard #include paths
    ENV["EXTRA_INCLUDE"] = "-I#{Formula["leptonica"].include} -I#{Formula["protobuf-c"].include/"protobuf-c"}"

    if OS.mac?
      platform = "mac"
      build_script = ["./build.command", "OCR"]
    else
      platform = "linux"
      build_script = ["./build", "-without-rust"]
    end

    cd platform do
      system(*build_script)
      bin.install "ccextractor"
    end
    (pkgshare/"examples").install "docs/ccextractor.cnf.sample"
  end

  test do
    resource("homebrew-test.mxf").stage do
      system bin/"ccextractor", "test.mxf", "-out=txt"
      assert_equal "This is a test video.", (Pathname.pwd/"test.txt").read.strip
    end
  end
end
