class GccAT11 < Formula
  desc "GNU compiler collection"
  homepage "https://gcc.gnu.org/"
  # TODO: Remove maximum_macos if Xcode 16 support is added to https://github.com/iains/gcc-11-branch
  url "https://ftp.gnu.org/gnu/gcc/gcc-11.5.0/gcc-11.5.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-11.5.0/gcc-11.5.0.tar.xz"
  sha256 "a6e21868ead545cf87f0c01f84276e4b5281d672098591c1c896241f09363478"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  livecheck do
    url :stable
    regex(%r{href=["']?gcc[._-]v?(11(?:\.\d+)+)(?:/?["' >]|\.t)}i)
  end

  bottle do
    sha256                               arm64_sonoma:   "55ec3e36278e110b74b148fefe5ccacf82223d0fb2fceb3c8230a03bfbc2857f"
    sha256                               arm64_ventura:  "b0936cf63d97795bfe8e17a9e4a4f75be0fd3f9407e467d5d02df1fba5caa499"
    sha256                               arm64_monterey: "85d430ddf596edf1f14639ca164d7370a46456c017008723392fcf9cd1f91bfa"
    sha256                               sonoma:         "9c0f839a23e3b7f12c72f3833823ca9cbd9d2b0e3a744e1d436daeeffc77cc82"
    sha256                               ventura:        "ceae737d0fe4ec0e8fc10356007d09c9250401443b5ccd632ee960a00004cba1"
    sha256                               monterey:       "af5d635ec43e4fc786abafe5f963ea26ac147ac10880d3ab4e2eea49948051cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7f02fea0754abb9c33f142cfc8d30bdc16d5d80a27ad2ca72ba562540bb1a44"
  end

  # The bottles are built on systems with the CLT installed, and do not work
  # out of the box on Xcode-only systems due to an incorrect sysroot.
  pour_bottle? only_if: :clt_installed

  depends_on maximum_macos: [:ventura, :build] # Xcode < 16
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
  # Apple Silicon support, located at https://github.com/iains/gcc-11-branch
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/5c9419923ddb3e5302ddd277bc524f4d4b0f8722/gcc/gcc-11.5.0.diff"
    sha256 "213b332bd09452e0cf081f874f32d028911fa871875f85b200b55c5b588ce193"
  end

  def install
    # GCC will suffer build errors if forced to use a particular linker.
    ENV.delete "LD"

    # We avoiding building:
    #  - Ada, which requires a pre-existing GCC Ada compiler to bootstrap
    #  - Go, currently not supported on macOS
    #  - BRIG
    languages = %w[c c++ objc obj-c++ fortran]
    languages << "d" if Hardware::CPU.intel?

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
    ]
    # libphobos is part of gdc
    args << "--enable-libphobos" if Hardware::CPU.intel?

    if OS.mac?
      cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
      args << "--build=#{cpu}-apple-darwin#{OS.kernel_version.major}"
      args << "--with-system-zlib"

      # System headers may not be in /usr/include
      sdk = MacOS.sdk_path_if_needed
      args << "--with-sysroot=#{sdk}" if sdk

      # Work around a bug in Xcode 15's new linker (FB13038083)
      if DevelopmentTools.clang_build_version >= 1500
        toolchain_path = "/Library/Developer/CommandLineTools"
        args << "--with-ld=#{toolchain_path}/usr/bin/ld-classic"
      end
    else
      # Fix cc1: error while loading shared libraries: libisl.so.15
      args << "--with-boot-ldflags=-static-libstdc++ -static-libgcc #{ENV.ldflags}"

      # Fix Linux error: gnu/stubs-32.h: No such file or directory.
      args << "--disable-multilib"

      # Change the default directory name for 64-bit libraries to `lib`
      # https://stackoverflow.com/a/54038769
      inreplace "gcc/config/i386/t-linux64", "m64=../lib64", "m64="
      inreplace "gcc/config/aarch64/t-aarch64-linux", "lp64=../lib64", "lp64="
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
      #   * `-nostdlib -L#{libgcc} -L#{glibc.opt_lib}` instructs gcc to use brewed glibc
      #     if applied.
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

    return unless Hardware::CPU.intel?

    (testpath/"hello_d.d").write <<~D
      import std.stdio;
      int main()
      {
        writeln("Hello, world!");
        return 0;
      }
    D
    system bin/"gdc-#{version.major}", "-o", "hello-d", "hello_d.d"
    assert_equal "Hello, world!\n", shell_output("./hello-d")
  end
end
