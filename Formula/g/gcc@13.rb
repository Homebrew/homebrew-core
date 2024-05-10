class GccAT13 < Formula
  desc "GNU compiler collection"
  homepage "https://gcc.gnu.org/"
  url "https://ftp.gnu.org/gnu/gcc/gcc-13.2.0/gcc-13.2.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-13.2.0/gcc-13.2.0.tar.xz"
  sha256 "e275e76442a6067341a27f04c5c6b83d8613144004c0413528863dc6b5c743da"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  livecheck do
    url :stable
    regex(%r{href=["']?gcc[._-]v?(13(?:\.\d+)+)(?:/?["' >]|\.t)}i)
  end

  bottle do
    sha256                               arm64_sonoma:   "d42a40f0b3c6367ce32f808caaff22ba5eea5d809c73d927e19b1651cf0a2319"
    sha256                               arm64_ventura:  "5f1e9dc1c4d4a65eaa4938799589954ae24c295749f8d3cd37452a1ebf8b71a4"
    sha256                               arm64_monterey: "42f35fb90af3eed08eacfe8c3bf0d30c7f1d12bd0cd6c087a5e21f5c643a0474"
    sha256                               sonoma:         "508e188f805503917201b062eb037300751e8c5df8f016942343618bbb7d30bb"
    sha256                               ventura:        "fb2403d97e2ce67eb441b54557cfb61980830f3ba26d4c5a1fe5ecd0c9730d1a"
    sha256                               monterey:       "af456b36cb6dddd276b35cd3d640228de06a162026e51280b99113e236f7adef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08778c5e405f7b0e4a4b8a68bdefc2098f1ea99ced0905e73223f94fc5b30d77"
  end

  # The bottles are built on systems with the CLT installed, and do not work
  # out of the box on Xcode-only systems due to an incorrect sysroot.
  pour_bottle? only_if: :clt_installed

  depends_on "gmp"
  depends_on "isl"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "zstd"

  uses_from_macos "zlib"

  on_linux do
    depends_on "binutils"
  end

  # GCC bootstraps itself, so it is OK to have an incompatible C++ stdlib
  cxxstdlib_check :skip

  # Branch from the Darwin maintainer of GCC, with a few generic fixes and
  # Apple Silicon support, located at https://github.com/iains/gcc-13-branch
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/3c5cbc8e9cf444a1967786af48e430588e1eb481/gcc/gcc-13.2.0.diff"
    sha256 "2df7ef067871a30b2531a2013b3db661ec9e61037341977bfc451e30bf2c1035"
  end

  # Fix a warning with Xcode 15's linker, remove in GCC 13.3
  # https://github.com/iains/gcc-13-branch/issues/11
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/e923a0cd6c0e60bb388e8a5b8cd1dcf9c3bf7758/gcc/gcc-xcode15-warnings.diff"
    sha256 "dcfec5f2209def06678fa9cf91bc7bbe38237f9f3a356a23ab66b84e88142b91"
  end

  # Upstream fixes for building against recent libc++, remove in GCC 13.3
  # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=111632
  patch do
    url "https://gcc.gnu.org/git/?p=gcc.git;a=commitdiff_plain;h=68057560ff1fc0fb2df38c2f9627a20c9a8da5c5"
    sha256 "4cb92b1b91ab9ef14f5aa440d17478b924e1b826e23ceb6a66262d3cc59081a8"
  end

  patch do
    url "https://gcc.gnu.org/git/?p=gcc.git;a=commitdiff_plain;h=e95ab9e60ce1d9aa7751d79291133fd5af9209d7"
    sha256 "d3fc6ed5ed1024e2765e02cc5ff3cf1f0be63659f1e588cfc36725c9a377d3cc"
  end

  # Upstream fix to deal with macOS 14 SDK <math.h> header, remove in GCC 13.3
  # https://gcc.gnu.org/git/?p=gcc.git;a=commitdiff;h=93f803d53b5ccaabded9d7b4512b54da81c1c616
  patch :DATA

  def install
    # GCC will suffer build errors if forced to use a particular linker.
    ENV.delete "LD"

    # We avoiding building:
    #  - Ada and D, which require a pre-existing GCC to bootstrap
    #  - Go, currently not supported on macOS
    #  - BRIG
    languages = %w[c c++ objc obj-c++ fortran]

    pkgversion = "Homebrew GCC #{pkg_version} #{build.used_options*" "}".strip

    args = %W[
      --prefix=#{opt_prefix}
      --libdir=#{opt_lib}/gcc/#{version.major}
      --disable-nls
      --enable-checking=release
      --with-gcc-major-version-only
      --enable-languages=#{languages.join(",")}
      --program-suffix=-#{version.major}
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

      # Enable to PIE by default to match what the host GCC uses
      args << "--enable-default-pie"

      # Change the default directory name for 64-bit libraries to `lib`
      # https://stackoverflow.com/a/54038769
      inreplace "gcc/config/i386/t-linux64", "m64=../lib64", "m64="
    end

    mkdir "build" do
      system "../configure", *args
      system "make"

      # Do not strip the binaries on macOS, it makes them unsuitable
      # for loading plugins
      install_target = OS.mac? ? "install" : "install-strip"

      # To make sure GCC does not record cellar paths, we configure it with
      # opt_prefix as the prefix. Then we use DESTDIR to install into a
      # temporary location, then move into the cellar path.
      system "make", install_target, "DESTDIR=#{Pathname.pwd}/../instdir"
      mv Dir[Pathname.pwd/"../instdir/#{opt_prefix}/*"], prefix
    end

    # Handle conflicts between GCC formulae and avoid interfering
    # with system compilers.
    # Rename man7.
    man7.glob("*.7") { |file| add_suffix file, version.major }
    # Even when we disable building info pages some are still installed.
    info.rmtree

    # Work around GCC install bug
    # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=105664
    rm_rf bin.glob("*-gcc-tmp")
  end

  def add_suffix(file, suffix)
    dir = File.dirname(file)
    ext = File.extname(file)
    base = File.basename(file, ext)
    File.rename file, "#{dir}/#{base}-#{suffix}#{ext}"
  end

  def post_install
    if OS.linux?
      gcc = bin/"gcc-#{version.major}"
      libgcc = Pathname.new(Utils.safe_popen_read(gcc, "-print-libgcc-file-name")).parent
      raise "command failed: #{gcc} -print-libgcc-file-name" if $CHILD_STATUS.exitstatus.nonzero?

      glibc = Formula["glibc"]
      glibc_installed = glibc.any_version_installed?

      # Symlink system crt1.o and friends where gcc can find it.
      crtdir = if glibc_installed
        glibc.opt_lib
      else
        Pathname.new(Utils.safe_popen_read("/usr/bin/cc", "-print-file-name=crti.o")).parent
      end
      ln_sf Dir[crtdir/"*crt?.o"], libgcc

      # Create the GCC specs file
      # See https://gcc.gnu.org/onlinedocs/gcc/Spec-Files.html

      # Locate the specs file
      specs = libgcc/"specs"
      ohai "Creating the GCC specs file: #{specs}"
      specs_orig = Pathname.new("#{specs}.orig")
      rm_f [specs_orig, specs]

      system_header_dirs = ["#{HOMEBREW_PREFIX}/include"]

      if glibc_installed
        # https://github.com/Linuxbrew/brew/issues/724
        system_header_dirs << glibc.opt_include
      else
        # Locate the native system header dirs if user uses system glibc
        target = Utils.safe_popen_read(gcc, "-print-multiarch").chomp
        raise "command failed: #{gcc} -print-multiarch" if $CHILD_STATUS.exitstatus.nonzero?

        system_header_dirs += ["/usr/include/#{target}", "/usr/include"]
      end

      # Save a backup of the default specs file
      specs_string = Utils.safe_popen_read(gcc, "-dumpspecs")
      raise "command failed: #{gcc} -dumpspecs" if $CHILD_STATUS.exitstatus.nonzero?

      specs_orig.write specs_string

      # Set the library search path
      # For include path:
      #   * `-isysroot #{HOMEBREW_PREFIX}/nonexistent` prevents gcc searching built-in
      #     system header files.
      #   * `-idirafter <dir>` instructs gcc to search system header
      #     files after gcc internal header files.
      # For libraries:
      #   * `-nostdlib -L#{libgcc} -L#{glibc.opt_lib}` instructs gcc to use
      #     brewed glibc if applied.
      #   * `-L#{libdir}` instructs gcc to find the corresponding gcc
      #     libraries. It is essential if there are multiple brewed gcc
      #     with different versions installed.
      #     Noted that it should only be passed for the `gcc@*` formulae.
      #   * `-L#{HOMEBREW_PREFIX}/lib` instructs gcc to find the rest
      #     brew libraries.
      # Note: *link will silently add #{libdir} first to the RPATH
      libdir = HOMEBREW_PREFIX/"lib/gcc/#{version.major}"
      specs.write specs_string + <<~EOS
        *cpp_unique_options:
        + -isysroot #{HOMEBREW_PREFIX}/nonexistent #{system_header_dirs.map { |p| "-idirafter #{p}" }.join(" ")}

        *link_libgcc:
        #{glibc_installed ? "-nostdlib -L#{libgcc} -L#{glibc.opt_lib}" : "+"} -L#{libdir} -L#{HOMEBREW_PREFIX}/lib

        *link:
        + --dynamic-linker #{HOMEBREW_PREFIX}/lib/ld.so -rpath #{libdir}

        *homebrew_rpath:
        -rpath #{HOMEBREW_PREFIX}/lib

      EOS
      inreplace(specs, " %o ", "\\0%(homebrew_rpath) ")
    end
  end

  test do
    (testpath/"hello-c.c").write <<~EOS
      #include <stdio.h>
      int main()
      {
        puts("Hello, world!");
        return 0;
      }
    EOS
    system "#{bin}/gcc-#{version.major}", "-o", "hello-c", "hello-c.c"
    assert_equal "Hello, world!\n", shell_output("./hello-c")

    (testpath/"hello-cc.cc").write <<~EOS
      #include <iostream>
      struct exception { };
      int main()
      {
        std::cout << "Hello, world!" << std::endl;
        try { throw exception{}; }
          catch (exception) { }
          catch (...) { }
        return 0;
      }
    EOS
    system "#{bin}/g++-#{version.major}", "-o", "hello-cc", "hello-cc.cc"
    assert_equal "Hello, world!\n", shell_output("./hello-cc")

    (testpath/"test.f90").write <<~EOS
      integer,parameter::m=10000
      real::a(m), b(m)
      real::fact=0.5

      do concurrent (i=1:m)
        a(i) = a(i) + fact*b(i)
      end do
      write(*,"(A)") "Done"
      end
    EOS
    system "#{bin}/gfortran-#{version.major}", "-o", "test", "test.f90"
    assert_equal "Done\n", shell_output("./test")
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
