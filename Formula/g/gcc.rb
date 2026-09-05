class Gcc < Formula
  desc "GNU compiler collection"
  homepage "https://gcc.gnu.org/"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }
  revision 1
  compatibility_version 2
  head "https://gcc.gnu.org/git/gcc.git", branch: "master"

  stable do
    url "https://ftpmirror.gnu.org/gnu/gcc/gcc-16.2.0/gcc-16.2.0.tar.xz"
    mirror "https://ftp.gnu.org/gnu/gcc/gcc-16.2.0/gcc-16.2.0.tar.xz"
    sha256 "e6738e29597f733270731aa90600f37ffdc045079dfc27ec7e8192cc81085c3e"

    # Branch from the Darwin maintainer of GCC, with a few generic fixes and
    # Apple Silicon support, located at https://github.com/iains/gcc-16-branch
    patch do
      on_macos do
        file "Patches/gcc/gcc-16.2.0.diff"
      end
    end
  end

  livecheck do
    url :stable
    regex(%r{href=["']?gcc[._-]v?(\d+(?:\.\d+)+)(?:/?["' >]|\.t)}i)
  end

  bottle do
    rebuild 1
    sha256               arm64_tahoe:   "add0ca0614da1d0047af8a71be683be40957096851f4c98ccd89e95b0c4f4fde"
    sha256               arm64_sequoia: "8c57a4e5c65c93b90b280e3e761833f946b5a7d186f2067d239af44b71c5a577"
    sha256               arm64_sonoma:  "2a23accb457b670c90e18d36bfbcfb212c7d0292a300881436a45630d64ed608"
    sha256 cellar: :any, arm64_linux:   "a816cc94416b72b6b90b87db9479b12addbb1b877603ecfc7157345621a1e2e9"
    sha256 cellar: :any, x86_64_linux:  "6504ecae947061ffe79c9dea2f635791bf54b148d1063ec857873eac2a67d922"
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

  def version_suffix
    if build.head?
      "HEAD"
    else
      version.major.to_s
    end
  end

  deny_network_access!

  def install
    # GCC will suffer build errors if forced to use a particular linker.
    ENV.delete "LD"

    # We avoiding building:
    #  - Ada and D, which require a pre-existing GCC to bootstrap
    #  - Cobol, not fully stable yet
    #  - Go, currently not supported on macOS
    #  - BRIG
    #  - Modula-2 on macOS, https://github.com/Homebrew/homebrew-core/pull/221029
    languages = %w[c c++ objc obj-c++ fortran algol68]
    languages << "m2" unless OS.mac?

    pkgversion = "Homebrew GCC #{pkg_version}"

    # Use `lib/gcc/current` to provide a path that doesn't change with GCC's version.
    args = %W[
      --prefix=#{opt_prefix}
      --libdir=#{opt_lib}/gcc/current
      --disable-nls
      --enable-checking=release
      --with-gcc-major-version-only
      --enable-languages=#{languages.join(",")}
      --program-suffix=-#{version_suffix}
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
      args << "--disable-multilib"
      args << "--with-linker-hash-style=gnu"

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
      # Do not strip the binaries on macOS, it makes them unsuitable for loading plugins
      install_target = OS.mac? ? "install" : "install-strip"

      # To make sure GCC does not record cellar paths, we configure it with
      # opt_prefix as the prefix. Then we use DESTDIR to install into a
      # temporary location, then move into the cellar path.
      system "../configure", *args
      system "gmake", *make_args
      system "gmake", install_target, "DESTDIR=#{buildpath}/instdir"
      prefix.install buildpath.glob("instdir/#{opt_prefix}/*")
    end

    bin.install_symlink bin/"gfortran-#{version_suffix}" => "gfortran"
    bin.install_symlink bin/"gm2-#{version_suffix}" => "gm2"

    # Provide a `lib/gcc/xy` directory to align with the versioned GCC formulae.
    # We need to create `lib/gcc/xy` as a directory and not a symlink to avoid `brew link` conflicts.
    (lib/"gcc"/version_suffix).install_symlink (lib/"gcc/current").children

    # Only the newest brewed gcc should install gfortan libs as we can only have one.
    lib.install_symlink lib.glob("gcc/current/libgfortran.*") if OS.linux?

    # Rename man7 to avoid conflicts between GCC formulae
    man7.glob("*.7") { |file| add_suffix file, version_suffix }
    # Even when we disable building info pages some are still installed.
    rm_r(info)
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

    (testpath/"hello.a68").write <<~ALGOL68
      begin
           puts("Hello, world!'n");
      end
    ALGOL68
    system bin/"ga68-#{version_suffix}", "-o", "hello-a68", "hello.a68"
    assert_equal "Hello, world!\n", shell_output("./hello-a68")

    # Modula-2 is temporarily disabled on macOS
    return if OS.mac?

    (testpath/"hello.mod").write <<~MODULA2
      MODULE hello;
      FROM InOut IMPORT WriteString, WriteLn;
      BEGIN
           WriteString("Hello, world!");
           WriteLn;
      END hello.
    MODULA2
    system bin/"gm2", "-o", "hello-m2", "hello.mod"
    assert_equal "Hello, world!\n", shell_output("./hello-m2")
  end
end
