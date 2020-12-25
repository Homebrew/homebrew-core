class Libgccjit < Formula
  # This is a spin-off of the GCC formula and they should remain as close as possible.
  desc "JIT library for the GNU compiler collection"
  homepage "https://gcc.gnu.org/"
  if Hardware::CPU.arch == :arm64
    # Branch from the Darwin maintainer of GCC with Apple Silicon support,
    # located at https://github.com/iains/gcc-darwin-arm64 and
    # backported with his help to gcc-10 branch. Too big for a patch.
    url "https://github.com/fxcoudert/gcc/archive/gcc-10-arm-20201223.tar.gz"
    sha256 "e4ec9a37bc96adb6a29e88dbef1b2dbe43e0b4014e91450d6b95ec7d238cdddb"
    version "10.2.0"
  else
    url "https://ftp.gnu.org/gnu/gcc/gcc-10.2.0/gcc-10.2.0.tar.xz"
    mirror "https://ftpmirror.gnu.org/gcc/gcc-10.2.0/gcc-10.2.0.tar.xz"
    sha256 "b8dd4368bb9c7f0b98188317ee0254dd8cc99d1e3a18d0ff146c855fe16c1d8c"
  end
  license any_of: ["GPL-3.0-or-later"]
  revision 1
  head "https://gcc.gnu.org/git/gcc.git"

  livecheck do
    # Should be
    # url :stable
    # but that does not work with the ARM-specific branch above
    url "https://ftp.gnu.org/gnu/gcc/gcc-10.2.0"
    regex(%r{href=.*?gcc[._-]v?(\d+(?:\.\d+)+)(?:/?["' >]|\.t)}i)
  end

  bottle do
    sha256 "e7354dc214f196f5a233fd437107fbe961bd6a5ffeacc1ae415a2f0bf2112f09" => :big_sur
    sha256 "4cf030080128753ca81ef1fd8a719435902b9153bc6549e6fa6cdafecebb2f49" => :catalina
    sha256 "af284969d6667e78eb576672a76ad80e7c23979cfdf91b3daad6873521aed1ba" => :mojave
    sha256 "c42884567811a2aae043a8fa44cbefe71da5bf2309e5e1489a22034b65736a19" => :high_sierra
  end

  # The bottles are built on systems with the CLT installed, and do not work
  # out of the box on Xcode-only systems due to an incorrect sysroot.
  pour_bottle? do
    reason "The bottle needs the Xcode CLT to be installed."
    satisfy { MacOS::CLT.installed? }
  end

  depends_on "gmp"
  depends_on "isl"
  depends_on "libmpc"
  depends_on "mpfr"

  uses_from_macos "zlib"

  conflicts_with "gcc", because: "both install `gcc` binaries & headers"

  # GCC bootstraps itself, so it is OK to have an incompatible C++ stdlib
  cxxstdlib_check :skip

  if Hardware::CPU.arch != :arm64
    # Patch for Big Sur version numbering, remove with GCC 11
    # https://github.com/iains/gcc-darwin-arm64/commit/556ab512
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/7baf6e2f/gcc/bigsur.diff"
      sha256 "42de3bc4889b303258a4075f88ad8624ea19384cab57a98a5270638654b83f41"
    end
  end

  def version_suffix
    if build.head?
      "HEAD"
    else
      version.major.to_s
    end
  end

  def install
    # GCC will suffer build errors if forced to use a particular linker.
    ENV.delete "LD"

    languages = %w[jit]

    pkgversion = "Homebrew GCC #{pkg_version} #{build.used_options*" "}".strip
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"

    args = %W[
      --build=#{cpu}-apple-darwin#{OS.kernel_version.major}
      --prefix=#{prefix}
      --libdir=#{lib}/gcc/#{version_suffix}
      --disable-nls
      --enable-checking=release
      --enable-languages=#{languages.join(",")}
      --program-suffix=-#{version_suffix}
      --with-gmp=#{Formula["gmp"].opt_prefix}
      --with-mpfr=#{Formula["mpfr"].opt_prefix}
      --with-mpc=#{Formula["libmpc"].opt_prefix}
      --with-isl=#{Formula["isl"].opt_prefix}
      --with-system-zlib
      --with-pkgversion=#{pkgversion}
      --with-bugurl=https://github.com/Homebrew/homebrew-core/issues
    ]

    # Xcode 10 dropped 32-bit support
    args << "--disable-multilib" if DevelopmentTools.clang_build_version >= 1000

    # System headers may not be in /usr/include
    sdk = MacOS.sdk_path_if_needed
    if sdk
      args << "--with-native-system-header-dir=/usr/include"
      args << "--with-sysroot=#{sdk}"
    end

    # Avoid reference to sed shim
    args << "SED=/usr/bin/sed"

    # Use -headerpad_max_install_names in the build,
    # otherwise updated load commands won't fit in the Mach-O header.
    # This is needed because `gcc` avoids the superenv shim.
    make_args = ["BOOT_LDFLAGS=-Wl,-headerpad_max_install_names"]

    # Building jit needs --enable-host-shared, which slows down the compiler.
    mkdir "build-jit" do
      system "../configure", *args, "--enable-languages=jit", "--enable-host-shared"
      system "make", *make_args
      system "make", "install"
    end

    #
    # Do some cleanup after installation so we keep only the things that
    # we actually need to use libgccjit (compilation & runtime).
    #

    # we need to keep one of the binaries in #{prefix}/bin as that is used
    # for gcc driver in libgccjit
    # -- see https://gcc.gnu.org/onlinedocs/jit/internals/index.html#envvar-PATH
    osmajor = `uname -r`.split(".").first

    Dir["#{bin}/*"].each do |f|
      rm_rf f unless File.basename(f).to_s == "#{cpu}-apple-darwin#{osmajor}-gcc-#{version}"
    end

    Dir["#{lib}/**/*"].each do |f|
      rm_rf f unless File.directory?(f) || File.basename(f).to_s.start_with?("libgcc")
    end

    rm_rf libexec
  end

  def caveats
    <<~EOS
      libgccjit requires LIBRARY_PATH to be set to #{HOMEBREW_PREFIX}/lib/gcc/#{version_suffix}
      in runtime.

      Add the following line to your .bashrc or equivalent:

        export LIBRARY_PATH="#{HOMEBREW_PREFIX}/lib/gcc/#{version_suffix}:$LIBRARY_PATH"

      Please see https://gcc.gnu.org/onlinedocs/jit/internals/index.html#environment-variables
      for more details.
    EOS
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

    system ENV.cc, "-I#{include}", "test-libgccjit.c", "-o", "test", "-L#{lib}/gcc/#{version_suffix}", "-lgccjit"
    assert_equal "hello world", shell_output("./test")
  end
end
