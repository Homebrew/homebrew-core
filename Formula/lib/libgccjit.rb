class Libgccjit < Formula
  desc "JIT library for the GNU compiler collection"
  homepage "https://gcc.gnu.org/"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }
  head "https://gcc.gnu.org/git/gcc.git", branch: "master"

  stable do
    url "https://ftp.gnu.org/gnu/gcc/gcc-14.2.0/gcc-14.2.0.tar.xz"
    mirror "https://ftpmirror.gnu.org/gcc/gcc-14.2.0/gcc-14.2.0.tar.xz"
    sha256 "a7b39bc69cbf9e25826c5a60ab26477001f7c08d85cec04bc0e29cabed6f3cc9"

    # Branch from the Darwin maintainer of GCC, with a few generic fixes and
    # Apple Silicon support, located at https://github.com/iains/gcc-14-branch
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/d5dcb918a951b2dcf2d7702db75eb29ef144f614/gcc/gcc-14.2.0.diff"
      sha256 "70a994d2c7861f844dbfc8ca2700f6c1ce9881f51c45bb6fda2fd212ccb1ff03"
    end
  end

  livecheck do
    formula "gcc"
  end

  bottle do
    sha256 arm64_sequoia:  "fff0020242ea84f9eb7c320035410213d831968cdffd746c0fb02460d13b8625"
    sha256 arm64_sonoma:   "1f863f51416d857e367f12accc84a6163742d77eec8f3c5644c6c79c334f4fd6"
    sha256 arm64_ventura:  "7605dcefda1dc4cdfa7b14303551dcade61408d4592e0eeb4b85aaa3d93dfc62"
    sha256 arm64_monterey: "d21962af68ea264a5b6a90265e6d1c7247377d5d41f5d021488380c15e804ed7"
    sha256 sonoma:         "e96b8c6f27911ddf6b66e20998eb678592b58906451a02e38e6a0256d7974603"
    sha256 ventura:        "bffe3af90300b16b02a98d00bfd95417141429abbcb53887ee1a1a177ffe3a35"
    sha256 monterey:       "baed769c2a3c93ace46dc2c01a585249f2f4ac4c941361b40c750c78b5bc25aa"
    sha256 x86_64_linux:   "809473f17318e15fe6ecf18d6ad50a80e2f03487bf4045e765833584ae6d4cec"
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

  on_macos do
    on_intel do
      depends_on "gcc"
    end
  end

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

    make_args = if OS.mac?
      cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
      args << "--build=#{cpu}-apple-darwin#{OS.kernel_version.major}"

      # System headers may not be in /usr/include
      sdk = MacOS.sdk_path_if_needed
      args << "--with-sysroot=#{sdk}" if sdk

      []
    else
      # Fix cc1: error while loading shared libraries: libisl.so.15
      args << "--with-boot-ldflags=-static-libstdc++ -static-libgcc #{ENV.ldflags}"

      # Fix Linux error: gnu/stubs-32.h: No such file or directory.
      args << "--disable-multilib"

      # Change the default directory name for 64-bit libraries to `lib`
      # https://stackoverflow.com/a/54038769
      inreplace "gcc/config/i386/t-linux64", "m64=../lib64", "m64="

      %W[
        BOOT_CFLAGS=-I#{Formula["zlib"].opt_include}
        BOOT_LDFLAGS=-I#{Formula["zlib"].opt_lib}
      ]
    end

    # Building jit needs --enable-host-shared, which slows down the compiler.
    mkdir "build-jit" do
      system "../configure", *args, "--enable-languages=jit", "--enable-host-shared"
      system "make", *make_args
      system "make", "install"
    end

    # We only install the relevant libgccjit files from libexec and delete the rest.
    prefix.find do |f|
      rm_r(f) if !f.directory? && !f.basename.to_s.start_with?("libgccjit")
    end

    # Provide a `lib/gcc/xy` directory to align with the versioned GCC formulae.
    (lib/"gcc"/version.major).install_symlink (lib/"gcc/current").children

    return if OS.linux? || Hardware::CPU.arm?

    lib.glob("gcc/current/#{shared_library("libgccjit", "*")}").each do |dylib|
      next if dylib.symlink?

      # Fix linkage with `libgcc_s.1.1`. See: Homebrew/discussions#5364
      gcc_libdir = Formula["gcc"].opt_lib/"gcc/current"
      MachO::Tools.add_rpath(dylib, rpath(source: lib/"gcc/current", target: gcc_libdir))
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
    libs = HOMEBREW_PREFIX/"lib/gcc/current"
    test_flags = %W[-I#{include} test-libgccjit.c -o test -L#{libs} -lgccjit]

    system gcc.to_s, *test_flags
    assert_equal "hello world", shell_output("./test")

    # The test below fails with the host compiler on Linux.
    return if OS.linux?

    # Also test with the host compiler, which many users use with libgccjit
    (testpath/"test").unlink
    system ENV.cc, *test_flags
    assert_equal "hello world", shell_output("./test")
  end
end
