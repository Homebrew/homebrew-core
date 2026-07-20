class GccAT10 < Formula
  desc "GNU compiler collection"
  homepage "https://gcc.gnu.org/"
  url "https://ftpmirror.gnu.org/gnu/gcc/gcc-10.5.0/gcc-10.5.0.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gcc/gcc-10.5.0/gcc-10.5.0.tar.xz"
  sha256 "25109543fdf46f397c347b5d8b7a2c7e5694a5a51cce4b9c6e1ea8a71ca307c1"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  # https://gcc.gnu.org/gcc-10/
  livecheck do
    skip "No longer developed or maintained"
  end

  bottle do
    sha256                               ventura:      "1155f38da440c96a9df1442152c3149755dfd369815cf8b967e9bbf2a4874489"
    sha256                               monterey:     "be699cd4f9c26c0023a28eb56e534058cac1ab1b2d06e57b531905cfde49b48e"
    sha256                               big_sur:      "5f40c454e3e3b96578411e28d6ba27679c6d3c182a978c60c3ea8f57f8235033"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "dc5bb71b10070e7b39378f8daa8192ddac000bbe731000898f8c250570a7e267"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "517a097236a0de677b0718462a752068ce32f5b6b86e044bdfc2fd7c2097207e"
  end

  # The bottles are built on systems with the CLT installed, and do not work
  # out of the box on Xcode-only systems due to an incorrect sysroot.
  pour_bottle? only_if: :clt_installed

  depends_on "gmp"
  depends_on "isl"
  depends_on "libmpc"
  depends_on "mpfr"

  on_macos do
    depends_on maximum_macos: [:ventura, :build]
    depends_on arch: :x86_64
    # Align dates to remove Intel macOS support with brew
    # https://docs.brew.sh/Support-Tiers#future-macos-support
    deprecate! date: "2025-09-18", because: :unsupported
    disable! date: "2026-09-18", because: :unsupported
  end

  on_linux do
    depends_on "binutils"
    depends_on "zlib-ng-compat"
    depends_on "zstd"
  end

  def version_suffix
    version.major.to_s
  end

  def install
    # GCC will suffer build errors if forced to use a particular linker.
    ENV.delete "LD"

    # Even when suffixes are appended, the info pages conflict when
    # install-info is run so pretend we have an outdated makeinfo
    # to prevent their build.
    ENV["gcc_cv_prog_makeinfo_modern"] = "no"

    # We avoiding building:
    #  - Ada, which requires a pre-existing GCC Ada compiler to bootstrap
    #  - Go, currently not supported on macOS
    #  - BRIG
    languages = %w[c c++ objc obj-c++ fortran]

    pkgversion = "Homebrew GCC #{pkg_version} #{build.used_options*" "}".strip

    args = %W[
      --prefix=#{prefix}
      --libdir=#{lib}/gcc/#{version_suffix}
      --disable-nls
      --enable-checking=release
      --enable-languages=#{languages.join(",")}
      --program-suffix=-#{version_suffix}
      --with-gmp=#{formula_opt_prefix("gmp")}
      --with-mpfr=#{formula_opt_prefix("mpfr")}
      --with-mpc=#{formula_opt_prefix("libmpc")}
      --with-isl=#{formula_opt_prefix("isl")}
      --with-pkgversion=#{pkgversion}
      --with-bugurl=#{tap.issues_url}
    ]

    if OS.mac?
      args << "--build=x86_64-apple-darwin#{OS.kernel_version.major}"
      args << "--with-system-zlib"

      # Xcode 10 dropped 32-bit support
      args << "--disable-multilib"

      # System headers may not be in /usr/include
      sdk = MacOS.sdk_path
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
      # https://www.linuxfromscratch.org/lfs/view/development/chapter06/gcc-pass2.html
      if Hardware::CPU.arm?
        inreplace "gcc/config/aarch64/t-aarch64-linux", "lp64=../lib64", "lp64="
      else
        inreplace "gcc/config/i386/t-linux64", "m64=../lib64", "m64="
      end
    end

    mkdir "build" do
      system "../configure", *args

      if OS.mac?
        # Use -headerpad_max_install_names in the build,
        # otherwise updated load commands won't fit in the Mach-O header.
        # This is needed because `gcc` avoids the superenv shim.
        system "make", "BOOT_LDFLAGS=-Wl,-headerpad_max_install_names"
        system "make", "install"
      else
        system "make"
        system "make", "install-strip"
      end
    end

    # Handle conflicts between GCC formulae and avoid interfering
    # with system compilers.
    # Rename man7.
    Dir.glob(man7/"*.7") { |file| add_suffix file, version_suffix }
    # Even when we disable building info pages some are still installed.
    rm_r(info)

    # Work around GCC install bug
    # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=105664
    rm_r(Dir[bin/"*-gcc-tmp"])
  end

  def add_suffix(file, suffix)
    dir = File.dirname(file)
    ext = File.extname(file)
    base = File.basename(file, ext)
    File.rename file, "#{dir}/#{base}-#{suffix}#{ext}"
  end

  post_install_steps do
    configure_gcc_runtime
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
    assert_equal "Hello, world!\n", `./hello-c`

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
    assert_equal "Hello, world!\n", `./hello-cc`

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
    assert_equal "Done\n", `./test`
  end
end
