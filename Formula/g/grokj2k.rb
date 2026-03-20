class Grokj2k < Formula
  desc "JPEG 2000 Library"
  homepage "https://github.com/GrokImageCompression/grok"
  url "https://github.com/GrokImageCompression/grok/releases/download/v20.1.0/source-full.tar.gz"
  sha256 "52287ba722299cb2afa229db25472e411c82e4685ca74ef5020f764a1ddc6eeb"
  license "AGPL-3.0-or-later"
  head "https://github.com/GrokImageCompression/grok.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e65a852cec04df1ba0ccd6606f64c14fa7c3f200784e7d8b0b5b4400050bdb69"
    sha256 cellar: :any,                 arm64_sequoia: "776a45e69c07f156242fe63a55dd61514f3f3b9ed21eafa456682f3a84a67336"
    sha256 cellar: :any,                 arm64_sonoma:  "568be73ac8d90e1d2354a1b645e9b2e29656b77599a3f3d5e35dea654c4afb15"
    sha256 cellar: :any,                 sonoma:        "21ae414e933b199b92e9b2155b7a328d0b453e3b43ae8ce9499560d7b1cc3433"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d1ab65abe53eb576c18f948015806cf299ac0da79b4912da7bab75018b50f2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92d0ac272c2633d20d53300ecbcf9716dc26cc280a7fabcea90eb9bd53c66b41"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkgconf" => :build
  depends_on "exiftool"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "little-cms2"

  uses_from_macos "perl"

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

  # Restore Highway target disables after the upstream include refactor stopped
  # pulling in grk_includes.h on Linux arm64. Upstream pr ref, https://github.com/GrokImageCompression/grok/pull/391
  patch :DATA

  def install
    # Fix: ExifTool Perl module not found
    ENV.prepend_path "PERL5LIB", Formula["exiftool"].opt_libexec/"lib/perl5"

    # Ensure we use Homebrew libraries
    %w[liblcms2 libpng libtiff libz].each { |l| rm_r(buildpath/"thirdparty"/l) }

    perl = DevelopmentTools.locate("perl")
    perl_archlib = Utils.safe_popen_read(perl.to_s, "-MConfig", "-e", "print $Config{archlib}")
    args = %W[
      -DGRK_BUILD_DOC=ON
      -DGRK_BUILD_JPEG=OFF
      -DGRK_BUILD_LCMS2=OFF
      -DGRK_BUILD_LIBPNG=OFF
      -DGRK_BUILD_LIBTIFF=OFF
      -DPERL_EXECUTABLE=#{perl}
    ]

    if OS.mac?
      # Workaround Perl 5.18 issues with C++11: pad.h:323:17: error: invalid suffix on literal
      ENV.append "CXXFLAGS", "-Wno-reserved-user-defined-literal" if MacOS.version <= :catalina
      # Help CMake find Perl libraries, which are needed to enable ExifTool feature.
      # Without this, CMake outputs: Could NOT find PerlLibs (missing: PERL_INCLUDE_PATH)
      args << "-DPERL_INCLUDE_PATH=#{MacOS.sdk_path_if_needed}/#{perl_archlib}/CORE"
    else
      # Fix linkage error due to RPATH missing directory with libperl.so
      ENV.append "LDFLAGS", "-Wl,-rpath,#{perl_archlib}/CORE"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    include.install_symlink "grok-#{version.major_minor}" => "grok"

    bin.env_script_all_files libexec, PERL5LIB: ENV["PERL5LIB"]
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

    # Test Exif metadata retrieval
    testpath.install resource("homebrew-test_image")
    system bin/"grk_compress", "--in-file", "basn6a08.tif",
                               "--out-file", "test.jp2", "--out-fmt", "jp2",
                               "--transfer-exif-tags"
    output = shell_output("#{Formula["exiftool"].bin}/exiftool test.jp2")

    expected_fields = [
      "Exif Byte Order                 : Big-endian (Motorola, MM)",
      "Orientation                     : Horizontal (normal)",
      "X Resolution                    : 72",
      "Y Resolution                    : 72",
      "Resolution Unit                 : inches",
      "Y Cb Cr Positioning             : Centered",
    ]

    expected_fields.each do |field|
      assert_match field, output
    end
  end
end

__END__
diff --git a/src/lib/core/point_transform/mct.cpp b/src/lib/core/point_transform/mct.cpp
index 7959f998f41b2ea6dceb40bd2cc30adba1347976..4502f7348a638d7f5101df40ace0d8d3b4be7585 100644
--- a/src/lib/core/point_transform/mct.cpp
+++ b/src/lib/core/point_transform/mct.cpp
@@ -53,6 +53,7 @@ struct ITileProcessor;
 
 #undef HWY_TARGET_INCLUDE
 #define HWY_TARGET_INCLUDE "point_transform/mct.cpp"
+#include "grk_includes.h"
 #include <hwy/foreach_target.h>
 #include <hwy/highway.h>
 HWY_BEFORE_NAMESPACE();
diff --git a/src/lib/core/util/lanes.cpp b/src/lib/core/util/lanes.cpp
index b8f50b4da0d249d32f5a26c21870426fccf6b0cf..f54caf5424aba988d72dd1f641499c9455d5b1e8 100644
--- a/src/lib/core/util/lanes.cpp
+++ b/src/lib/core/util/lanes.cpp
@@ -17,6 +17,7 @@
 
 #undef HWY_TARGET_INCLUDE
 #define HWY_TARGET_INCLUDE "lanes.cpp"
+#include "grk_includes.h"
 #include <hwy/foreach_target.h>
 #include <hwy/highway.h>
 
diff --git a/src/lib/core/wavelet/WaveletFwd.cpp b/src/lib/core/wavelet/WaveletFwd.cpp
index 2a7874d2397fd32bd0b708f21077fef6f3123036..818ee2fe8bdfc1dcaa811bc1ed15288db5fc1aaa 100644
--- a/src/lib/core/wavelet/WaveletFwd.cpp
+++ b/src/lib/core/wavelet/WaveletFwd.cpp
@@ -51,6 +51,7 @@ struct ITileProcessor;
 
 #undef HWY_TARGET_INCLUDE
 #define HWY_TARGET_INCLUDE "wavelet/WaveletFwd.cpp"
+#include "grk_includes.h"
 #include <hwy/foreach_target.h>
 #include <hwy/highway.h>
 HWY_BEFORE_NAMESPACE();
diff --git a/src/lib/core/wavelet/WaveletReverse.cpp b/src/lib/core/wavelet/WaveletReverse.cpp
index 31049c9cd6909887d4bbaeb8f4e85745d7f9c33a..003a0ee9b2f09bb75c26fe969d436b7486416f54 100644
--- a/src/lib/core/wavelet/WaveletReverse.cpp
+++ b/src/lib/core/wavelet/WaveletReverse.cpp
@@ -74,6 +74,7 @@ struct ITileProcessor;
 
 #undef HWY_TARGET_INCLUDE
 #define HWY_TARGET_INCLUDE "wavelet/WaveletReverse.cpp"
+#include "grk_includes.h"
 #include <hwy/foreach_target.h>
 #include <hwy/highway.h>
 
diff --git a/src/lib/core/wavelet/WaveletReverse97.cpp b/src/lib/core/wavelet/WaveletReverse97.cpp
index 2289945f626d9628049bdefa18530851a51947f4..22dd35e6cb4f63b98dc40b53779f30ae68f79975 100644
--- a/src/lib/core/wavelet/WaveletReverse97.cpp
+++ b/src/lib/core/wavelet/WaveletReverse97.cpp
@@ -68,6 +68,7 @@ namespace grk
 
 #undef HWY_TARGET_INCLUDE
 #define HWY_TARGET_INCLUDE "wavelet/WaveletReverse97.cpp"
+#include "grk_includes.h"
 #include <hwy/foreach_target.h>
 #include <hwy/highway.h>
 
