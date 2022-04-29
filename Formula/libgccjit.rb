class Libgccjit < Formula
  desc "JIT library for the GNU compiler collection"
  homepage "https://gcc.gnu.org/"
  url "https://ftp.gnu.org/gnu/gcc/gcc-12.1.0/gcc-12.1.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-12.1.0/gcc-12.1.0.tar.xz"
  sha256 "62fd634889f31c02b64af2c468f064b47ad1ca78411c45abe6ac4b5f8dd19c7b"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }
  head "https://gcc.gnu.org/git/gcc.git", branch: "master"

  livecheck do
    formula "gcc"
  end

  bottle do
    sha256 arm64_monterey: "cb67919738ceaf2dc52ad6eda4b981cf3ef09034a506980de526a0a72f78b380"
    sha256 arm64_big_sur:  "ac5e717fe292f83c5a3c49ed76c0f47d1f968d6b24089b2ee5021682908ad935"
    sha256 monterey:       "9f0d50538e40657c82c891846d77c3193e4b39bcf4504429b11738fe0155d075"
    sha256 big_sur:        "4cce8e0cf231b7d52cb17cdd45af65d340bac1a8b6b2d76c15bab4544f1c778f"
    sha256 catalina:       "da0b032249866a6a74d6f0a7dd44cc2465261fd3becf847fcaafdf4a2750509c"
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

  # Branch from the Darwin maintainer of GCC, with a few generic fixes and
  # Apple Silicon support, located at https://github.com/iains/gcc-darwin-arm64
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/d61235ed/gcc/gcc-12.1.0-arm.diff"
    sha256 "1e8b95e2649866678bf3aaa358028e8c5c611593c61f90e41aaa937ad5f589ed"
  end

  def install
    # GCC will suffer build errors if forced to use a particular linker.
    ENV.delete "LD"

    pkgversion = "Homebrew GCC #{pkg_version} #{build.used_options*" "}".strip

    args = %W[
      --prefix=#{prefix}
      --libdir=#{lib}/gcc/#{version.major}
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
      if sdk
        args << "--with-native-system-header-dir=/usr/include"
        args << "--with-sysroot=#{sdk}"
      end
    else
      # Fix cc1: error while loading shared libraries: libisl.so.15
      args << "--with-boot-ldflags=-static-libstdc++ -static-libgcc #{ENV["LDFLAGS"]}"

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
    Dir["#{prefix}/**/*"].each do |f|
      rm_rf f if !File.directory?(f) && !File.basename(f).to_s.start_with?("libgccjit")
    end
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
