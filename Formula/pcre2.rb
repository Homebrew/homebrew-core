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
    sha256 cellar: :any,                 arm64_big_sur: "7bdcd1b4fa7a511b2c4250033a65508aa1b7ea43d8379946a96fd496e5d401fc"
    sha256 cellar: :any,                 big_sur:       "981738c8279de442ac2fc83fa61e9cdf75e5c26b19a6d7fc2179362da2d522f7"
    sha256 cellar: :any,                 catalina:      "6ab918e130104bc0c4155e1d25e9691e542703071f1b48c41cc123605e3558ff"
    sha256 cellar: :any,                 mojave:        "2b0ec328faea65cfa6466fb9cf1eb6a081dd5046decc31e448e81966bbacf87b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86281e59dc950af9e0421744376587ee045f58a3a71ec63b57ede4de5cd222fd"
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
 
