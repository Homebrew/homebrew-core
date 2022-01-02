class Ccextractor < Formula
  desc "Free, GPL licensed closed caption tool"
  homepage "https://www.ccextractor.org/"
  url "https://github.com/CCExtractor/ccextractor/archive/v0.94.tar.gz"
  sha256 "9c7be386257c69b5d8cd9d7466dbf20e3a45cea950cc8ca7486a956c3be54a42"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/ccextractor/ccextractor.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0e159214a166b4a94b01af8132843ab7d965a1eac9ab381a4c32218928dabb73"
    sha256 cellar: :any,                 arm64_big_sur:  "4499ba31cb70fb44486f740f40c737fea8ee4b9c5f8bd6a4339769c5d7f8f498"
    sha256 cellar: :any,                 monterey:       "eb8ca60f26962005c03c1585564acd0b6bfbf9e831c2926be7189ebbe963702a"
    sha256 cellar: :any,                 big_sur:        "3451b54658fb17d68a8cf869529f23877420d9684ab3da21998db11a8b4f2762"
    sha256 cellar: :any,                 catalina:       "a65daeb04e584ce5adb862e3f26878be5adb72dd9cf802e1ab4c3a782554f88a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f71cb35f1a330e06b1a6477170c00f843ef0cdbf52898bfd4fc182d44365c25d"
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
