class Pcre2 < Formula
  desc "Perl compatible regular expressions library with a new API"
  homepage "https://www.pcre.org/"
  license "BSD-3-Clause"
  revision 1
  head "svn://vcs.exim.org/pcre2/code/trunk"

  # remove stable block on next release with merged patch
  stable do
    url "https://ftp.pcre.org/pub/pcre/pcre2-10.37.tar.bz2"
    sha256 "4d95a96e8b80529893b4562be12648d798b957b1ba1aae39606bbc2ab956d270"

    # fix invalid single character repetition issues in JIT
    # upstream revision: https://vcs.pcre.org/pcre2?view=revision&revision=1315
    # remove in the next release
    patch :DATA
  end

  livecheck do
    url "https://ftp.pcre.org/pub/pcre/"
    regex(/href=.*?pcre2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "eeda1a0642a9e2a3f32d0588605f29e2a5671dc6bd9e45394c3026cd79786c64"
    sha256 cellar: :any,                 big_sur:       "2e885570c4dc2eaa61e7a02c66631f9333bbb42f8602d8293e7ce022861ae11e"
    sha256 cellar: :any,                 catalina:      "0e40c8534a5fc26eedbbfb487cf437e8b231e0054ccb61c696834416b7160ac7"
    sha256 cellar: :any,                 mojave:        "c6932648a712a0603d786b4b8868a21519eeb13592cf49261359c3c4b0c5665e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6ec10a997623297bbbf00d0d5854235694c7326ea0296690f89416d7e32ddba"
  end

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-pcre2-16
      --enable-pcre2-32
      --enable-pcre2grep-libz
      --enable-pcre2grep-libbz2
    ]

    # JIT not currently supported for Apple Silicon
    args << "--enable-jit" unless Hardware::CPU.arm?

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"pcre2grep", "regular expression", prefix/"README"
  end
end

__END__
--- a/src/pcre2_jit_compile.c
+++ b/src/pcre2_jit_compile.c
@@ -1236,15 +1236,16 @@ start:
 
 return: current number of iterators enhanced with fast fail
 */
-static int detect_early_fail(compiler_common *common, PCRE2_SPTR cc, int *private_data_start, sljit_s32 depth, int start)
+static int detect_early_fail(compiler_common *common, PCRE2_SPTR cc, int *private_data_start,
+   sljit_s32 depth, int start, BOOL fast_forward_allowed)
 {
 PCRE2_SPTR begin = cc;
 PCRE2_SPTR next_alt;
 PCRE2_SPTR end;
 PCRE2_SPTR accelerated_start;
+BOOL prev_fast_forward_allowed;
 int result = 0;
 int count;
-BOOL fast_forward_allowed = TRUE;
 
 SLJIT_ASSERT(*cc == OP_ONCE || *cc == OP_BRA || *cc == OP_CBRA);
 SLJIT_ASSERT(*cc != OP_CBRA || common->optimized_cbracket[GET2(cc, 1 + LINK_SIZE)] != 0);
@@ -1476,6 +1477,7 @@ do
       case OP_CBRA:
       end = cc + GET(cc, 1);
 
+      prev_fast_forward_allowed = fast_forward_allowed;
       fast_forward_allowed = FALSE;
       if (depth >= 4)
         break;
@@ -1484,7 +1486,7 @@ do
       if (*end != OP_KET || (*cc == OP_CBRA && common->optimized_cbracket[GET2(cc, 1 + LINK_SIZE)] == 0))
         break;
 
-      count = detect_early_fail(common, cc, private_data_start, depth + 1, count);
+      count = detect_early_fail(common, cc, private_data_start, depth + 1, count, prev_fast_forward_allowed);
 
       if (PRIVATE_DATA(cc) != 0)
         common->private_data_ptrs[begin - common->start] = 1;
@@ -13657,7 +13659,7 @@ memset(common->private_data_ptrs, 0, total_length * sizeof(sljit_s32));
 private_data_size = common->cbra_ptr + (re->top_bracket + 1) * sizeof(sljit_sw);
 
 if ((re->overall_options & PCRE2_ANCHORED) == 0 && (re->overall_options & PCRE2_NO_START_OPTIMIZE) == 0 && !common->has_skip_in_assert_back)
-  detect_early_fail(common, common->start, &private_data_size, 0, 0);
+  detect_early_fail(common, common->start, &private_data_size, 0, 0, TRUE);
 
 set_private_data_ptrs(common, &private_data_size, ccend);
 
