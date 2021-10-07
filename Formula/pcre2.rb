class Pcre2 < Formula
  desc "Perl compatible regular expressions library with a new API"
  homepage "https://www.pcre.org/"
  license "BSD-3-Clause"

  # remove stable block on next release with merged patch
  stable do
    url "https://github.com/PhilipHazel/pcre2/releases/download/pcre2-10.38/pcre2-10.38.tar.bz2"
    sha256 "7d95aa7c8a7b0749bf03c4bd73626ab61dece7e3986b5a57f5ec39eebef6b07c"

    # fix incorrect detection of alternatives in first character search with JIT
    # upstream revision: https://github.com/PhilipHazel/pcre2/commit/e7af7efaa11f71b187b0432e9e60f18ba4d90a0c
    # remove in the next release
    patch :DATA
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
    system "./autogen.sh" if build.head?
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
diff --git a/src/pcre2_jit_compile.c b/src/pcre2_jit_compile.c
index 495920de..2c614065 100644
--- a/src/pcre2_jit_compile.c
+++ b/src/pcre2_jit_compile.c
@@ -1251,10 +1251,13 @@ SLJIT_ASSERT(*cc == OP_ONCE || *cc == OP_BRA || *cc == OP_CBRA);
 SLJIT_ASSERT(*cc != OP_CBRA || common->optimized_cbracket[GET2(cc, 1 + LINK_SIZE)] != 0);
 SLJIT_ASSERT(start < EARLY_FAIL_ENHANCE_MAX);
 
+next_alt = cc + GET(cc, 1);
+if (*next_alt == OP_ALT)
+  fast_forward_allowed = FALSE;
+
 do
   {
   count = start;
-  next_alt = cc + GET(cc, 1);
   cc += 1 + LINK_SIZE + ((*cc == OP_CBRA) ? IMM2_SIZE : 0);
 
   while (TRUE)
@@ -1512,7 +1515,7 @@ do
         {
         count++;
 
-        if (fast_forward_allowed && *next_alt == OP_KET)
+        if (fast_forward_allowed)
           {
           common->fast_forward_bc_ptr = accelerated_start;
           common->private_data_ptrs[(accelerated_start + 1) - common->start] = ((*private_data_start) << 3) | type_skip;
@@ -1562,8 +1565,8 @@ do
   else if (result < count)
     result = count;
 
-  fast_forward_allowed = FALSE;
   cc = next_alt;
+  next_alt = cc + GET(cc, 1);
   }
 while (*cc == OP_ALT);
 
