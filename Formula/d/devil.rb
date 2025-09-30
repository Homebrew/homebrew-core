class Devil < Formula
  desc "Cross-platform image library"
  homepage "https://sourceforge.net/projects/openil/"
  license "LGPL-2.1-only"
  revision 6
  head "https://github.com/DentonW/DevIL.git", branch: "master"

  stable do
    url "https://downloads.sourceforge.net/project/openil/DevIL/1.8.0/DevIL-1.8.0.tar.gz"
    sha256 "0075973ee7dd89f0507873e2580ac78336452d29d34a07134b208f44e2feb709"

    # jpeg 9 compatibility
    # Upstream commit from 3 Jan 2017 "Fixed int to boolean conversion error
    # under Linux"
    patch do
      url "https://github.com/DentonW/DevIL/commit/41fcabbe.patch?full_index=1"
      sha256 "324dc09896164bef75bb82b37981cc30dfecf4f1c2386c695bb7e92a2bb8154d"
    end

    # jpeg 9 compatibility
    # Upstream commit from 7 Jan 2017 "Fixing boolean compilation errors under
    # Linux / MacOS, issue #48 at https://github.com/DentonW/DevIL/issues/48"
    patch do
      url "https://github.com/DentonW/DevIL/commit/4a2d7822.patch?full_index=1"
      sha256 "7e74a4366ef485beea1c4285f2b371b6bfa0e2513b83d4d45e4e120690c93f1d"
    end

    # allow compiling against jasper >= 2.0.17
    patch do
      url "https://github.com/DentonW/DevIL/commit/42a62648.patch?full_index=1"
      sha256 "b3a99c34cd7f9a5681f43dc0886fe360ba7d1df2dd1eddd7fcdcae7898f7a68e"
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "b38672c3417c92fde8b5cca2a59f14c31201f9a5f043a1bb5d7d04c4983d5398"
    sha256 cellar: :any,                 arm64_sequoia:  "06f0d3689766e92e01e492d9abbceeac345df99fa96a018cf74963ff4b6c9cca"
    sha256 cellar: :any,                 arm64_sonoma:   "80cb4184d2621711c7ebfce994578930a3f8dce0c1f9e0c1115b1de2ea1fa174"
    sha256 cellar: :any,                 arm64_ventura:  "83917219939802394eed0c286c61eb01f54621d97fe434838286a2ec5f92e939"
    sha256 cellar: :any,                 arm64_monterey: "f653e1ed04c2c3e1c4d00e9c9f9e237e2cd062ba1a9bd12417f4081c572b4ab5"
    sha256 cellar: :any,                 arm64_big_sur:  "543768d33075adb7d3301fff8a8376a0ebf014401783f10ae68bf896e2996b36"
    sha256 cellar: :any,                 sonoma:         "98d8eaf39ca55e189b6add8d199d4527adbba229a7eaf170d5d21b7b41848dc2"
    sha256 cellar: :any,                 ventura:        "41c4a55d025dbe6bb13fe38575289bca95014da52ecebb5d06091521eba82598"
    sha256 cellar: :any,                 monterey:       "e981eb27631eb67d08126eee9daef0de6f30223bf69f4cc497e6d258d84d4714"
    sha256 cellar: :any,                 big_sur:        "1bf545866859e8ed264015e2e0c9f88e8379f7ec175ef40ade2e1039ce933262"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "35dca23ab5cbd470f6dfe8744a7ed0f7a414366215d0350c89819ca0b03d083e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39cfc26d4075c7e2be8b1fcc8ae762bd8897dca6460c632e1b63f3df69888a56"
  end

  depends_on "cmake" => :build
  depends_on "jasper"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "little-cms2"

  # allow compiling against jasper >= 3.0.0
  patch :DATA

  def install
    system "cmake", "-S", "DevIL", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <IL/il.h>
      int main() {
        ilInit();
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-o", "test", "-I#{include}",
                    "-L#{lib}", "-lIL", "-lILU"
    system "./test"
  end
end

__END__
diff --git a/DevIL/src-IL/src/il_jp2.cpp b/DevIL/src-IL/src/il_jp2.cpp
index 89075a52..f46028a9 100644
--- a/DevIL/src-IL/src/il_jp2.cpp
+++ b/DevIL/src-IL/src/il_jp2.cpp
@@ -323,7 +323,9 @@ ILboolean iLoadJp2Internal(jas_stream_t	*Stream, ILimage *Image)
 //
 // see: https://github.com/OSGeo/gdal/commit/9ef8e16e27c5fc4c491debe50bf2b7f3e94ed334
 //      https://github.com/DentonW/DevIL/issues/90
-#if defined(PRIjas_seqent)
+#if JAS_VERSION_MAJOR >= 3
+static ssize_t iJp2_file_read(jas_stream_obj_t *obj, char *buf, size_t cnt)
+#elif defined(PRIjas_seqent)
 static int iJp2_file_read(jas_stream_obj_t *obj, char *buf, unsigned cnt)
 #else
 static int iJp2_file_read(jas_stream_obj_t *obj, char *buf, int cnt)
@@ -333,7 +335,9 @@ static int iJp2_file_read(jas_stream_obj_t *obj, char *buf, int cnt)
 	return iread(buf, 1, cnt);
 }

-#if defined(JAS_INCLUDE_JP2_CODEC)
+#if JAS_VERSION_MAJOR >= 3
+static ssize_t iJp2_file_write(jas_stream_obj_t *obj, const char *buf, size_t cnt)
+#elif defined(JAS_INCLUDE_JP2_CODEC)
 static int iJp2_file_write(jas_stream_obj_t *obj, const char *buf, unsigned cnt)
 #elif defined(PRIjas_seqent)
 static int iJp2_file_write(jas_stream_obj_t *obj, char *buf, unsigned cnt)
