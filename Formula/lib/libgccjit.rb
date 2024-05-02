class Libgccjit < Formula
  desc "JIT library for the GNU compiler collection"
  homepage "https://gcc.gnu.org/"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }
  head "https://gcc.gnu.org/git/gcc.git", branch: "master"

  stable do
    url "https://ftp.gnu.org/gnu/gcc/gcc-13.2.0/gcc-13.2.0.tar.xz"
    mirror "https://ftpmirror.gnu.org/gcc/gcc-13.2.0/gcc-13.2.0.tar.xz"
    sha256 "e275e76442a6067341a27f04c5c6b83d8613144004c0413528863dc6b5c743da"

    # Branch from the Darwin maintainer of GCC, with a few generic fixes and
    # Apple Silicon support, located at https://github.com/iains/gcc-13-branch
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/3c5cbc8e9cf444a1967786af48e430588e1eb481/gcc/gcc-13.2.0.diff"
      sha256 "2df7ef067871a30b2531a2013b3db661ec9e61037341977bfc451e30bf2c1035"
    end

    # Fix a warning with Xcode 15's linker
    # https://github.com/iains/gcc-13-branch/issues/11
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/e923a0cd6c0e60bb388e8a5b8cd1dcf9c3bf7758/gcc/gcc-xcode15-warnings.diff"
      sha256 "dcfec5f2209def06678fa9cf91bc7bbe38237f9f3a356a23ab66b84e88142b91"
    end

    # Upstream fix to deal with macOS 14 SDK <math.h> header
    # https://gcc.gnu.org/git/?p=gcc.git;a=commitdiff;h=93f803d53b5ccaabded9d7b4512b54da81c1c616
    patch :DATA
  end

  livecheck do
    formula "gcc"
  end

  bottle do
    rebuild 2
    sha256 arm64_sonoma:   "9667addea1fa7fab2a18ef4a4472187a777cf0d5fe209439b02c1dd2e7690e3d"
    sha256 arm64_ventura:  "046a00c2dbe83d2b8469dcdb6233fe368a90e015f02144b490b194f59fe94875"
    sha256 arm64_monterey: "a5e9e6d5397316e6e19e3080ee982d80816b4e40eb89db6a60d52d949a913452"
    sha256 sonoma:         "b01b088771fdfe609aaf16d02876ca4e17bed4b07b3b95d29edd8057908752fb"
    sha256 ventura:        "1a395b57d3ea2a95724887f3217edba84574e0aa9209041189957bfff82b1716"
    sha256 monterey:       "faf52fc39e7d51ba8e49208c33a870268ea3e30c9b824f5594110ce8e705e1ab"
    sha256 x86_64_linux:   "a003c14aa29362dc72745d20fd6d129b9cacf6b4772a0149888fddb5641ca462"
  end

  # The bottles are built on systems with the CLT installed, and do not work
  # out of the box on Xcode-only systems due to an incorrect sysroot.
  pour_bottle? only_if: :clt_installed

  depends_on "gcc" => :test
  depends_on "gmp"
  depends_on "isl"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "zstd"

  uses_from_macos "zlib"

  # GCC bootstraps itself, so it is OK to have an incompatible C++ stdlib
  cxxstdlib_check :skip

  def install
    # GCC will suffer build errors if forced to use a particular linker.
    ENV.delete "LD"

    pkgversion = "Homebrew GCC #{pkg_version} #{build.used_options*" "}".strip

    # Use `lib/gcc/current` to align with the GCC formula.
    args = %W[
      --prefix=#{prefix}
      --libdir=#{lib}/gcc/current
      --disable-nls
      --enable-checking=release
      --with-gcc-major-version-only
      --with-gmp=#{Formula["gmp"].opt_prefix}
      --with-mpfr=#{Formula["mpfr"].opt_prefix}
      --with-mpc=#{Formula["libmpc"].opt_prefix}
      --with-isl=#{Formula["isl"].opt_prefix}
      --with-zstd=#{Formula["zstd"].opt_prefix}
      --with-pkgversion=#{pkgversion}
      --with-bugurl=#{tap.issues_url}
      --with-system-zlib
    ]

    if OS.mac?
      cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
      args << "--build=#{cpu}-apple-darwin#{OS.kernel_version.major}"

      # System headers may not be in /usr/include
      sdk = MacOS.sdk_path_if_needed
      args << "--with-sysroot=#{sdk}" if sdk
    else
      # Fix cc1: error while loading shared libraries: libisl.so.15
      args << "--with-boot-ldflags=-static-libstdc++ -static-libgcc #{ENV.ldflags}"

      # Fix Linux error: gnu/stubs-32.h: No such file or directory.
      args << "--disable-multilib"

      # Change the default directory name for 64-bit libraries to `lib`
      # https://stackoverflow.com/a/54038769
      inreplace "gcc/config/i386/t-linux64", "m64=../lib64", "m64="
    end

    # Building jit needs --enable-host-shared, which slows down the compiler.
    mkdir "build-jit" do
      system "../configure", *args, "--enable-languages=jit", "--enable-host-shared"
      system "make"
      system "make", "install"
    end

    # We only install the relevant libgccjit files from libexec and delete the rest.
    prefix.find do |f|
      rm_rf f if !f.directory? && !f.basename.to_s.start_with?("libgccjit")
    end

    # Provide a `lib/gcc/xy` directory to align with the versioned GCC formulae.
    (lib/"gcc"/version.major).install_symlink (lib/"gcc/current").children
  end

  test do
    (testpath/"test-libgccjit.c").write <<~EOS
      #include <libgccjit.h>
      #include <stdlib.h>
      #include <stdio.h>

      static void create_code (gcc_jit_context *ctxt) {
          gcc_jit_type *void_type = gcc_jit_context_get_type (ctxt, GCC_JIT_TYPE_VOID);
          gcc_jit_type *const_char_ptr_type = gcc_jit_context_get_type (ctxt, GCC_JIT_TYPE_CONST_CHAR_PTR);
          gcc_jit_param *param_name = gcc_jit_context_new_param (ctxt, NULL, const_char_ptr_type, "name");
          gcc_jit_function *func = gcc_jit_context_new_function (ctxt, NULL, GCC_JIT_FUNCTION_EXPORTED,
                  void_type, "greet", 1, &param_name, 0);
          gcc_jit_param *param_format = gcc_jit_context_new_param (ctxt, NULL, const_char_ptr_type, "format");
          gcc_jit_function *printf_func = gcc_jit_context_new_function (ctxt, NULL, GCC_JIT_FUNCTION_IMPORTED,
                  gcc_jit_context_get_type (ctxt, GCC_JIT_TYPE_INT), "printf", 1, &param_format, 1);
          gcc_jit_rvalue *args[2];
          args[0] = gcc_jit_context_new_string_literal (ctxt, "hello %s");
          args[1] = gcc_jit_param_as_rvalue (param_name);
          gcc_jit_block *block = gcc_jit_function_new_block (func, NULL);
          gcc_jit_block_add_eval (block, NULL, gcc_jit_context_new_call (ctxt, NULL, printf_func, 2, args));
          gcc_jit_block_end_with_void_return (block, NULL);
      }

      int main (int argc, char **argv) {
          gcc_jit_context *ctxt;
          gcc_jit_result *result;
          ctxt = gcc_jit_context_acquire ();
          if (!ctxt) {
              fprintf (stderr, "NULL ctxt");
              exit (1);
          }
          gcc_jit_context_set_bool_option (ctxt, GCC_JIT_BOOL_OPTION_DUMP_GENERATED_CODE, 0);
          create_code (ctxt);
          result = gcc_jit_context_compile (ctxt);
          if (!result) {
              fprintf (stderr, "NULL result");
              exit (1);
          }
          typedef void (*fn_type) (const char *);
          fn_type greet = (fn_type)gcc_jit_result_get_code (result, "greet");
          if (!greet) {
              fprintf (stderr, "NULL greet");
              exit (1);
          }
          greet ("world");
          fflush (stdout);
          gcc_jit_context_release (ctxt);
          gcc_jit_result_release (result);
          return 0;
      }
    EOS

    gcc_major_ver = Formula["gcc"].any_installed_version.major
    gcc = Formula["gcc"].opt_bin/"gcc-#{gcc_major_ver}"
    libs = "#{HOMEBREW_PREFIX}/lib/gcc/#{gcc_major_ver}"

    system gcc.to_s, "-I#{include}", "test-libgccjit.c", "-o", "test", "-L#{libs}", "-lgccjit"
    assert_equal "hello world", shell_output("./test")
  end
end
__END__
diff --git a/fixincludes/fixincl.x b/fixincludes/fixincl.x
index 416d2c2e3a4..e52f11d8460 100644
--- a/fixincludes/fixincl.x
+++ b/fixincludes/fixincl.x
@@ -2,11 +2,11 @@
  *
  * DO NOT EDIT THIS FILE   (fixincl.x)
  *
- * It has been AutoGen-ed  January 22, 2023 at 09:03:29 PM by AutoGen 5.18.12
+ * It has been AutoGen-ed  August 17, 2023 at 10:16:38 AM by AutoGen 5.18.12
  * From the definitions    inclhack.def
  * and the template file   fixincl
  */
-/* DO NOT SVN-MERGE THIS FILE, EITHER Sun Jan 22 21:03:29 CET 2023
+/* DO NOT SVN-MERGE THIS FILE, EITHER Thu Aug 17 10:16:38 CEST 2023
  *
  * You must regenerate it.  Use the ./genfixes script.
  *
@@ -3674,7 +3674,7 @@ tSCC* apzDarwin_Flt_Eval_MethodMachs[] = {
  *  content selection pattern - do fix if pattern found
  */
 tSCC zDarwin_Flt_Eval_MethodSelect0[] =
-       "^#if __FLT_EVAL_METHOD__ == 0$";
+       "^#if __FLT_EVAL_METHOD__ == 0( \\|\\| __FLT_EVAL_METHOD__ == -1)?$";
 
 #define    DARWIN_FLT_EVAL_METHOD_TEST_CT  1
 static tTestDesc aDarwin_Flt_Eval_MethodTests[] = {
@@ -3685,7 +3685,7 @@ static tTestDesc aDarwin_Flt_Eval_MethodTests[] = {
  */
 static const char* apzDarwin_Flt_Eval_MethodPatch[] = {
     "format",
-    "#if __FLT_EVAL_METHOD__ == 0 || __FLT_EVAL_METHOD__ == 16",
+    "%0 || __FLT_EVAL_METHOD__ == 16",
     (char*)NULL };
 
 /* * * * * * * * * * * * * * * * * * * * * * * * * *
diff --git a/fixincludes/inclhack.def b/fixincludes/inclhack.def
index 45e0cbc0c10..19e0ea2df66 100644
--- a/fixincludes/inclhack.def
+++ b/fixincludes/inclhack.def
@@ -1819,10 +1819,11 @@ fix = {
     hackname  = darwin_flt_eval_method;
     mach      = "*-*-darwin*";
     files     = math.h;
-    select    = "^#if __FLT_EVAL_METHOD__ == 0$";
+    select    = "^#if __FLT_EVAL_METHOD__ == 0( \\|\\| __FLT_EVAL_METHOD__ == -1)?$";
     c_fix     = format;
-    c_fix_arg = "#if __FLT_EVAL_METHOD__ == 0 || __FLT_EVAL_METHOD__ == 16";
-    test_text = "#if __FLT_EVAL_METHOD__ == 0";
+    c_fix_arg = "%0 || __FLT_EVAL_METHOD__ == 16";
+    test_text = "#if __FLT_EVAL_METHOD__ == 0\n"
+		"#if __FLT_EVAL_METHOD__ == 0 || __FLT_EVAL_METHOD__ == -1";
 };
 
 /*
diff --git a/fixincludes/tests/base/math.h b/fixincludes/tests/base/math.h
index 29b67579748..7b92f29a409 100644
--- a/fixincludes/tests/base/math.h
+++ b/fixincludes/tests/base/math.h
@@ -32,6 +32,7 @@
 
 #if defined( DARWIN_FLT_EVAL_METHOD_CHECK )
 #if __FLT_EVAL_METHOD__ == 0 || __FLT_EVAL_METHOD__ == 16
+#if __FLT_EVAL_METHOD__ == 0 || __FLT_EVAL_METHOD__ == -1 || __FLT_EVAL_METHOD__ == 16
 #endif  /* DARWIN_FLT_EVAL_METHOD_CHECK */
 
 
-- 
2.39.3
