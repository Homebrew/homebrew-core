class Grokj2k < Formula
  desc "JPEG 2000 Library"
  homepage "https://github.com/GrokImageCompression/grok"
  url "https://github.com/GrokImageCompression/grok/releases/download/v20.3.12/source-full.tar.gz"
  sha256 "9e241fed4aebaf4662d6495fa357e357887427791512facd19b2d7b6509cc362"
  license "AGPL-3.0-or-later"
  head "https://github.com/GrokImageCompression/grok.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c73fa1dc75bde05d109f13b8edac9013f72d64cf871218b436526eac5dd14586"
    sha256 cellar: :any, arm64_sequoia: "f1019ee9fdf7d718b289eac7b7e707670ac797a56d6013aab7ca3238d00533c6"
    sha256 cellar: :any, arm64_sonoma:  "2c004af5a6cf8dfc9b144c058089fefea5ecdeb4f995732185f1dbf08523fc2d"
    sha256 cellar: :any, sonoma:        "e14752332cf8849267416c43d4a7eaf76e13d5de3b7cef5ab0f6dd6b2f4ff73f"
    sha256 cellar: :any, arm64_linux:   "cc5875d1161be2ffb612802b60f0ce4630a464a0742de6dd36b81f261d45fa22"
    sha256 cellar: :any, x86_64_linux:  "f52a8f14c5507eea4927dd785b15f1df89526482ceba873299c44fa932290e31"
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

  def install
    # Ensure we use Homebrew libraries
    %w[liblcms2 libpng libtiff libz].each { |l| rm_r(buildpath/"thirdparty"/l) }

    args = %w[
      -DGRK_BUILD_DOC=OFF
      -DGRK_BUILD_JPEG=OFF
      -DGRK_BUILD_LCMS2=OFF
      -DGRK_BUILD_LIBPNG=OFF
      -DGRK_BUILD_LIBTIFF=OFF
      -DSPDLOG_FMT_EXTERNAL=ON
    ]

    if OS.mac? && MacOS.version <= :catalina
      # Workaround Perl 5.18 issues with C++11: pad.h:323:17: error: invalid suffix on literal
      ENV.append "CXXFLAGS", "-Wno-reserved-user-defined-literal"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    include.install_symlink "grok-#{version.major_minor}" => "grok"
  end

  test do
    resource "homebrew-test_image" do
      url "https://github.com/GrokImageCompression/grok-test-data/raw/43ce4cb/input/nonregression/basn6a08.tif"
      sha256 "d0b9715d79b10b088333350855f9721e3557b38465b1354b0fa67f230f5679f3"
    end

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
    output = shell_output("#{Formula["exiftool"].bin}/exiftool test.jp2")

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
