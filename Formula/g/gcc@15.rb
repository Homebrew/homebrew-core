class GccAT15 < Formula
  desc "GNU compiler collection"
  homepage "https://gcc.gnu.org/"
  url "https://ftpmirror.gnu.org/gnu/gcc/gcc-15.3.0/gcc-15.3.0.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gcc/gcc-15.3.0/gcc-15.3.0.tar.xz"
  sha256 "fa59c1beef8995f27c4d71c1df227587189315d3e6faff1bb4306e61b0c530eb"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  livecheck do
    url :stable
    regex(%r{href=["']?gcc[._-]v?(15(?:\.\d+)+)(?:/?["' >]|\.t)}i)
  end

  bottle do
    rebuild 1
    sha256               arm64_tahoe:   "9d1a7c3069a0c1359c6b5453ad8030b3d7744696bb6c5c46a2bd54b46a3caabc"
    sha256               arm64_sequoia: "6b2ef487a9bbe2f0f3aac11938fd4faf345447afa366f8511072b6be28f42342"
    sha256               arm64_sonoma:  "0f461330c058f4e9dce23dfa3942d3a6e716ad0555abf70cfff6bee4a2621ca5"
    sha256               tahoe:         "a32f2ecc0e5ac64a5eca96a13e439f4358553d234eaccee5f8ccf1ba7b6e7fb2"
    sha256               sequoia:       "3414427989c7601d4294bdfac3690877ce230aeb920a047e3b6ae9d2273e6870"
    sha256               sonoma:        "c5d05388d0bbd34d30cdd81a70db9d81c680712f96d4fa9a00bd7f43fc188d00"
    sha256 cellar: :any, arm64_linux:   "683745e655a72723fdfe3ee2902dc994c449d6a7813c3a04ad277100a43e4a2c"
    sha256 cellar: :any, x86_64_linux:  "926b74086c0e13dc7cfa9002d6d005ccc5cbebd8b64546d278f4ccae90f32b61"
  end

  # The bottles are built on systems with the CLT installed, and do not work
  # out of the box on Xcode-only systems due to an incorrect sysroot.
  pour_bottle? only_if: :clt_installed

  depends_on "gmp"
  depends_on "isl"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "zstd"

  uses_from_macos "flex" => :build
  uses_from_macos "m4" => :build

  on_macos do
    # macOS make is too old, has intermittent parallel build issue
    depends_on "make" => :build
  end

  on_linux do
    depends_on "binutils"
    depends_on "zlib-ng-compat"
  end

  # Branch from the Darwin maintainer of GCC, with a few generic fixes and
  # Apple Silicon support, located at https://github.com/iains/gcc-15-branch
  patch do
    on_macos do
      file "Patches/gcc/gcc-15.3.0.diff"
    end
  end

  def install
    # GCC will suffer build errors if forced to use a particular linker.
    ENV.delete "LD"

    # We avoiding building:
    #  - Ada and D, which require a pre-existing GCC to bootstrap
    #  - Cobol, not fully stable yet
    #  - Go, currently not supported on macOS
    #  - BRIG
    languages = %w[c c++ objc obj-c++ fortran]

    # Modula-2 has problems with macOS 15 for now
    # https://github.com/Homebrew/homebrew-core/pull/221029
    languages << "m2" if !OS.mac? || MacOS.version < :sequoia

    pkgversion = "Homebrew GCC #{pkg_version} #{build.used_options*" "}".strip

    args = %W[
      --prefix=#{opt_prefix}
      --libdir=#{opt_lib}/gcc/#{version.major}
      --disable-nls
      --enable-checking=release
      --with-gcc-major-version-only
      --enable-languages=#{languages.join(",")}
      --program-suffix=-#{version.major}
      --with-gmp=#{formula_opt_prefix("gmp")}
      --with-mpfr=#{formula_opt_prefix("mpfr")}
      --with-mpc=#{formula_opt_prefix("libmpc")}
      --with-isl=#{formula_opt_prefix("isl")}
      --with-zstd=#{formula_opt_prefix("zstd")}
      --with-pkgversion=#{pkgversion}
      --with-bugurl=#{tap.issues_url}
      --with-system-zlib
    ]

    if OS.mac?
      cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
      args << "--build=#{cpu}-apple-darwin#{OS.kernel_version.major}"

      # System headers may not be in /usr/include
      sdk = MacOS.sdk_path
      args << "--with-sysroot=#{sdk}" if sdk

      # Avoid this semi-random failure:
      # "Error: Failed changing install name"
      # "Updated load commands do not fit in the header"
      make_args = %w[
        BOOT_LDFLAGS=-Wl,-headerpad_max_install_names
        LDFLAGS_FOR_TARGET=-Wl,-headerpad_max_install_names
      ]
    else
      # Fix Linux error: gnu/stubs-32.h: No such file or directory.
      args << "--disable-multilib"

      # Enable to PIE by default to match what the host GCC uses
      args << "--enable-default-pie"

      # Change the default directory name for 64-bit libraries to `lib`
      # https://stackoverflow.com/a/54038769
      inreplace "gcc/config/i386/t-linux64", "m64=../lib64", "m64="
      inreplace "gcc/config/aarch64/t-aarch64-linux", "lp64=../lib64", "lp64="

      ENV.append_path "CPATH", formula_opt_include("zlib-ng-compat")
      ENV.append_path "LIBRARY_PATH", formula_opt_lib("zlib-ng-compat")
    end

    mkdir "build" do
      system "../configure", *args
      system "gmake", *make_args

      # Do not strip the binaries on macOS, it makes them unsuitable
      # for loading plugins
      install_target = OS.mac? ? "install" : "install-strip"

      # To make sure GCC does not record cellar paths, we configure it with
      # opt_prefix as the prefix. Then we use DESTDIR to install into a
      # temporary location, then move into the cellar path.
      system "gmake", install_target, "DESTDIR=#{Pathname.pwd}/../instdir"
      mv Dir[Pathname.pwd/"../instdir/#{opt_prefix}/*"], prefix
    end

    # Handle conflicts between GCC formulae and avoid interfering
    # with system compilers.
    # Rename man7.
    man7.glob("*.7") { |file| add_suffix file, version.major }
    # Even when we disable building info pages some are still installed.
    rm_r(info)

    # Work around GCC install bug
    # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=105664
    rm_r(bin.glob("*-gcc-tmp"))
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
      rm([specs_orig, specs].select(&:exist?))

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
    (testpath/"hello-c.c").write <<~C
      #include <stdio.h>
      int main()
      {
        puts("Hello, world!");
        return 0;
      }
    C
    system bin/"gcc-#{version.major}", "-o", "hello-c", "hello-c.c"
    assert_equal "Hello, world!\n", shell_output("./hello-c")

    (testpath/"hello-cc.cc").write <<~CPP
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
    CPP
    system bin/"g++-#{version.major}", "-o", "hello-cc", "hello-cc.cc"
    assert_equal "Hello, world!\n", shell_output("./hello-cc")

    (testpath/"test.f90").write <<~FORTRAN
      integer,parameter::m=10000
      real::a(m), b(m)
      real::fact=0.5

      do concurrent (i=1:m)
        a(i) = a(i) + fact*b(i)
      end do
      write(*,"(A)") "Done"
      end
    FORTRAN
    system bin/"gfortran-#{version.major}", "-o", "test", "test.f90"
    assert_equal "Done\n", shell_output("./test")

    # Modula-2 is temporarily disabled on macOS 15
    return if OS.mac? && MacOS.version >= :sequoia

    (testpath/"hello.mod").write <<~EOS
      MODULE hello;
      FROM InOut IMPORT WriteString, WriteLn;
      BEGIN
           WriteString("Hello, world!");
           WriteLn;
      END hello.
    EOS
    system bin/"gm2-#{version.major}", "-o", "hello-m2", "hello.mod"
    assert_equal "Hello, world!\n", shell_output("./hello-m2")
  end
end
