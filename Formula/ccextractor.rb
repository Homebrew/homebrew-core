class Ccextractor < Formula
  desc "Free, GPL licensed closed caption tool"
  homepage "https://www.ccextractor.org/"
  url "https://github.com/CCExtractor/ccextractor/archive/v0.94.tar.gz"
  sha256 "9c7be386257c69b5d8cd9d7466dbf20e3a45cea950cc8ca7486a956c3be54a42"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/ccextractor/ccextractor.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2921edfc33b26f792398dfbf85806ea3c26e3c74606fbf9fad69e19132a93633"
    sha256 cellar: :any,                 arm64_big_sur:  "720a3d22c73a265a998dbab7a964e12f024fa010c31252684c8606ec39abf498"
    sha256 cellar: :any,                 monterey:       "050b1f5cb459d30810e584d8ab21041db0442f904e3bda4b83abf4979a47fa59"
    sha256 cellar: :any,                 big_sur:        "a36cf52162b6f847e16de881ec74dfc3468b893b939dde44445ec78f92c930b4"
    sha256 cellar: :any,                 catalina:       "2d69f8155bd877d19cf90681b34ea1183ee0f10c3262887f4c16f8d9cd956a34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d1b026a171e1a894bd3e7ea306eba0a2d7a4894978618ebc5ffd05ed96cea68"
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
