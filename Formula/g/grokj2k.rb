class Grokj2k < Formula
  desc "JPEG 2000 Library"
  homepage "https://github.com/GrokImageCompression/grok"
  url "https://github.com/GrokImageCompression/grok/releases/download/v21.0.0/source-full.tar.gz"
  sha256 "7d7f388e773ddc7a0215fb1ef5e4a8060edcecf15261518251e1bca6bf850f84"
  license "AGPL-3.0-or-later"
  head "https://github.com/GrokImageCompression/grok.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "a7aedc41552c88e16cae18ff21f99d091052959a1144b1a7ae12c000e5814059"
    sha256 cellar: :any, arm64_golden_gate: "fccb9ac4a283bfa11c9226589782c37dc7f73ec0199aea880aaee52f8bbd8efc"
    sha256 cellar: :any, arm64_tahoe:       "bafc4b6fdce2a92907104bcec273aaa9e3065e2bfb5bd72c438ad24e4c3fa9d9"
    sha256 cellar: :any, arm64_sequoia:     "e5181a27a01212f5316110130fe9d7daa0b44b098156f5de5e525d384a36c205"
    sha256 cellar: :any, arm64_linux:       "6bf284b2480b63945668366c9113541a62e5561649d8829813f66ee3752d8a26"
    sha256 cellar: :any, x86_64_linux:      "83cce642899b16babc7ecc65f1a48bb33569926b3c378d3565141bc51ae9a131"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "exiftool" => :test
  depends_on "fmt"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "little-cms2"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version < 1700
    depends_on "xz"
    depends_on "zstd"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  fails_with :clang do
    build 1699
    cause "Requires C++20"
  end

  # https://github.com/GrokImageCompression/grok/blob/master/INSTALL.md#compilers
  fails_with :gcc do
    version "9"
    cause "GNU compiler version must be at least 10.0"
  end

  resource "homebrew-test_image", :test do
    url "https://github.com/GrokImageCompression/grok-test-data/raw/43ce4cb/input/nonregression/basn6a08.tif"
    sha256 "d0b9715d79b10b088333350855f9721e3557b38465b1354b0fa67f230f5679f3"
  end

  allow_network_access! :test

  def install
    # Ensure we use Homebrew libraries
    %w[liblcms2 libpng libtiff libz].each { |l| rm_r(buildpath/"thirdparty"/l) }

    args = %w[
      -DGRK_BUILD_CORE_EXAMPLES=OFF
      -DGRK_BUILD_DOC=OFF
      -DGRK_BUILD_JPEG=OFF
      -DGRK_BUILD_LCMS2=OFF
      -DGRK_BUILD_LIBPNG=OFF
      -DGRK_BUILD_LIBTIFF=OFF
      -DSPDLOG_FMT_EXTERNAL=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    include.install_symlink "grok-#{version.major_minor}" => "grok"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <grok/grok.h>

      int main () {
        grk_image_comp cmptparm;
        const GRK_COLOR_SPACE color_space = GRK_CLRSPC_GRAY;

        grk_image *image;
        image = grk_image_new(1, &cmptparm, color_space, true);

        grk_object_unref(&image->obj);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lgrokj2k", "-o", "test"
    system "./test"

    # Test metadata preservation
    testpath.install resource("homebrew-test_image")
    system bin/"grk_compress", "--in-file", "basn6a08.tif",
                               "--out-file", "test.jp2", "--out-fmt", "jp2"
    output = shell_output("#{formula_opt_bin("exiftool")}/exiftool test.jp2")

    expected_fields = [
      "Capture X Resolution            : 2835",
      "Capture Y Resolution            : 2835",
      "Capture X Resolution Unit       : m",
      "Capture Y Resolution Unit       : m",
    ]

    expected_fields.each do |field|
      assert_match field, output
    end
  end
end
