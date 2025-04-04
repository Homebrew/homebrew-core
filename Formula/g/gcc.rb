class Gcc < Formula
  desc "GNU compiler collection"
  homepage "https://gcc.gnu.org/"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }
  revision 1
  head "https://gcc.gnu.org/git/gcc.git", branch: "master"

  stable do
    url "https://ftp.gnu.org/gnu/gcc/gcc-14.2.0/gcc-14.2.0.tar.xz"
    mirror "https://ftpmirror.gnu.org/gcc/gcc-14.2.0/gcc-14.2.0.tar.xz"
    sha256 "a7b39bc69cbf9e25826c5a60ab26477001f7c08d85cec04bc0e29cabed6f3cc9"

    # Branch from the Darwin maintainer of GCC, with a few generic fixes and
    # Apple Silicon support, located at https://github.com/iains/gcc-14-branch
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/f30c309442a60cfb926e780eae5d70571f8ab2cb/gcc/gcc-14.2.0-r2.diff"
      sha256 "6c0a4708f35ccf2275e6401197a491e3ad77f9f0f9ef5761860768fa6da14d3d"
    end
  end

  livecheck do
    url :stable
    regex(%r{href=["']?gcc[._-]v?(\d+(?:\.\d+)+)(?:/?["' >]|\.t)}i)
  end

  bottle do
    sha256                               arm64_sequoia: "96d8bf02f621cfa180cfe6c466fe0aff2cf3f48eab52ea5a5232cdd2a5cc30c4"
    sha256                               arm64_sonoma:  "4d94c81d3aea48d77d6e7d7d359d05b48024bac44ade59e08dc3fe0f62539a17"
    sha256                               arm64_ventura: "2869b13880fbe3d3d9d074e3b5f2dbf3bd0593f826d11b8b10165fd489b94deb"
    sha256                               sequoia:       "548e5453b0cbf88fe86d63aeef2dacfa7eacc030ccdf037113add3040d64db50"
    sha256                               sonoma:        "901263863f3f4e8b99f9ffb1cccdb00e5fe74fd1013ac79d37af7ce07f600123"
    sha256                               ventura:       "7832d72cd4f578e244d5b920f2523e77b8f30328229440a569afa5a88df353fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30f36e423478a258611d19828af3f9a330a2bbe4272c1391262f69ca36837e1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0902085b2185b224dd20c2ee5f12d83284cdbb68d0dab1e2edbd4c6603545de6"
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

  # GCC bootstraps itself, so it is OK to have an incompatible C++ stdlib
  cxxstdlib_check :skip

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
    #  - Go, currently not supported on macOS
    #  - BRIG
    languages = %w[c c++ objc obj-c++ fortran m2]

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

      make_args = []
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
      inreplace "gcc/config/aarch64/t-aarch64-linux", "lp64=../lib64", "lp64="

      make_args = %W[
        BOOT_CFLAGS=-I#{Formula["zlib"].opt_include}
        BOOT_LDFLAGS=-L#{Formula["zlib"].opt_lib}
      ]
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
    return unless OS.linux?

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

    target = Utils.safe_popen_read(gcc, "-dumpmachine").chomp
    raise "command failed: #{gcc} -dumpmachine" if $CHILD_STATUS.exitstatus.nonzero?

    mkheaders = libexec/"gcc"/target/version.major/"install-tools/mkheaders"
    ohai "Running #{mkheaders}"
    system mkheaders
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
