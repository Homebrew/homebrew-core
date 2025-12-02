class Gcc < Formula
  desc "GNU compiler collection"
  homepage "https://gcc.gnu.org/"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }
  head "https://gcc.gnu.org/git/gcc.git", branch: "master"

  stable do
    url "https://ftpmirror.gnu.org/gnu/gcc/gcc-15.2.0/gcc-15.2.0.tar.xz"
    mirror "https://ftp.gnu.org/gnu/gcc/gcc-15.2.0/gcc-15.2.0.tar.xz"
    sha256 "438fd996826b0c82485a29da03a72d71d6e3541a83ec702df4271f6fe025d24e"

    # Branch from the Darwin maintainer of GCC, with a few generic fixes and
    # Apple Silicon support, located at https://github.com/iains/gcc-14-branch
    patch do
      on_macos do
        url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/gcc/gcc-15.1.0.diff"
        sha256 "360fba75cd3ab840c2cd3b04207f745c418df44502298ab156db81d41edf3594"
      end
    end
  end

  livecheck do
    url :stable
    regex(%r{href=["']?gcc[._-]v?(\d+(?:\.\d+)+)(?:/?["' >]|\.t)}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256                               arm64_tahoe:   "e76be6aae85a3a541420be141c63e314444a7dfaaa5594778cf34b79eee81385"
    sha256                               arm64_sequoia: "aef7b1f77984d6a599b4d5a4002d91b777debea49bdc429be9a0fc13cfd82974"
    sha256                               arm64_sonoma:  "ae72dbd9b2ba010e956db687b36fee950190dfaa5e33299aedb61c50ec2ebccf"
    sha256                               tahoe:         "bdb8459b23eb33ba9d503fa8effb6bb79ab59953d2643d5538e90d9ce95447b4"
    sha256                               sequoia:       "1c6c40e6317501b4158402b3ddab8a138b5ddd7dcecfc661c28a49a95770b325"
    sha256                               sonoma:        "9b8c47ed04d0dcee9c133ddef1861868252fa6263245fbc6a03ce1e147b0815d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "714ff308f7f00d71d0d7122cd777f12185c1eafe21254b7033edd0e6a8fbaafc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eebab9738ff2c231ec19c5da5725a830d89322914f8aa84d58728c6b45f84a58"
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
  uses_from_macos "zlib"

  on_macos do
    # macOS make is too old, has intermittent parallel build issue
    depends_on "make" => :build
  end

  on_linux do
    depends_on "binutils"
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

    # Use `lib/gcc/current` to provide a path that doesn't change with GCC's version.
    args = %W[
      --prefix=#{opt_prefix}
      --libdir=#{opt_lib}/gcc/current
      --disable-nls
      --enable-checking=release
      --with-gcc-major-version-only
      --enable-languages=#{languages.join(",")}
      --program-suffix=-#{version_suffix}
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

      # Avoid this semi-random failure:
      # "Error: Failed changing install name"
      # "Updated load commands do not fit in the header"
      make_args = %w[BOOT_LDFLAGS=-Wl,-headerpad_max_install_names]
    else
      # Fix Linux error: gnu/stubs-32.h: No such file or directory.
      args << "--disable-multilib"

      # Enable to PIE by default to match what the host GCC uses
      args << "--enable-default-pie"

      # Change the default directory name for 64-bit libraries to `lib`
      # https://stackoverflow.com/a/54038769
      inreplace "gcc/config/i386/t-linux64", "m64=../lib64", "m64="
      inreplace "gcc/config/aarch64/t-aarch64-linux", "lp64=../lib64", "lp64="

      ENV.append_path "CPATH", Formula["zlib"].opt_include
      ENV.append_path "LIBRARY_PATH", Formula["zlib"].opt_lib
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

    bin.install_symlink bin/"gfortran-#{version_suffix}" => "gfortran"
    bin.install_symlink bin/"gm2-#{version_suffix}" => "gm2"

    # Provide a `lib/gcc/xy` directory to align with the versioned GCC formulae.
    # We need to create `lib/gcc/xy` as a directory and not a symlink to avoid `brew link` conflicts.
    (lib/"gcc"/version_suffix).install_symlink (lib/"gcc/current").children

    # Only the newest brewed gcc should install gfortan libs as we can only have one.
    lib.install_symlink lib.glob("gcc/current/libgfortran.*") if OS.linux?

    # Handle conflicts between GCC formulae and avoid interfering
    # with system compilers.
    # Rename man7.
    man7.glob("*.7") { |file| add_suffix file, version_suffix }
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
      gcc = bin/"gcc-#{version_suffix}"
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
      libdir = HOMEBREW_PREFIX/"lib/gcc/current"
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
    system bin/"gcc-#{version_suffix}", "-o", "hello-c", "hello-c.c"
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
    system bin/"g++-#{version_suffix}", "-o", "hello-cc", "hello-cc.cc"
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
    system bin/"gfortran", "-o", "test", "test.f90"
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
    system bin/"gm2", "-o", "hello-m2", "hello.mod"
    assert_equal "Hello, world!\n", shell_output("./hello-m2")
  end
end
