class GccAT12 < Formula
  desc "GNU compiler collection"
  homepage "https://gcc.gnu.org/"
  url "https://ftpmirror.gnu.org/gnu/gcc/gcc-12.4.0/gcc-12.4.0.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gcc/gcc-12.4.0/gcc-12.4.0.tar.xz"
  sha256 "704f652604ccbccb14bdabf3478c9511c89788b12cb3bbffded37341916a9175"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  # https://gcc.gnu.org/gcc-12/
  # TODO: skip livecheck after 12.5.0
  livecheck do
    url :stable
    regex(%r{href=["']?gcc[._-]v?(12(?:\.\d+)+)(?:/?["' >]|\.t)}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256                               arm64_tahoe:  "121d1e1d67b1888295afb2b4bf70462ea6c4ea463eaa348d660c262f1af1b31e"
    sha256                               arm64_sonoma: "1353f50ebf74f089cce988339ddc829659763e6ec7ca6f6bb59d1e14d6e08227"
    sha256                               sonoma:       "6704c981da00d008481eb0b5f28b25b94e41fc658f05820b95b49ba8f38041cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "9a0052fd91cc298b1cd3b18c9e107470b4131187980cb744514ce6d8ff4d36a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e4d0fd3bea4b3fef919188847d7e62129749e1fb88f62aba8f99a0e9d1af38d3"
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

  # Branch from the Darwin maintainer of GCC, with a few generic fixes and
  # Apple Silicon support, located at https://github.com/iains/gcc-12-branch
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/gcc/gcc-12.4.0.diff"
    sha256 "c0e8e94fbf65a6ce13286e7f13beb5a1d84b182a610489026ce3e2420fc3d45c"
  end
  # Backport commits to build on Sonoma/Sequoia to allow rebottling.
  # TODO: merge into above patch when updating to 12.5.0.
  patch do
    on_macos do
      url "https://github.com/iains/gcc-12-branch/compare/e300c1337a48cf772b09e7136601fd7f9f09d6f1..99533d94172ed7a24c0e54c4ea97e6ae2260409e.patch"
      sha256 "f01bf173c1980cef680e407a5cc4f34af13a3e54cd644138735ec35adc5c6e40"
    end
  end

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

      # Work around a bug in Xcode 15's new linker (FB13038083)
      if DevelopmentTools.clang_build_version >= 1500
        toolchain_path = "/Library/Developer/CommandLineTools"
        args << "--with-ld=#{toolchain_path}/usr/bin/ld-classic"
      end
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
  end
end
