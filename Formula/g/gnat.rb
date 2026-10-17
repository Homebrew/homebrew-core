class Gnat < Formula
  desc "GNU New York University Ada Trans"
  homepage "https://gcc.gnu.org/"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }
  compatibility_version 2
  head "https://gcc.gnu.org/git/gcc.git", branch: "master"

  stable do
    url "https://ftpmirror.gnu.org/gcc/gcc-16.2.0/gcc-16.2.0.tar.xz"
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
    formula "gcc"
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

  resource "bootstrap_gnat" do
    on_macos do
      on_arm do
        url "https://github.com/alire-project/GNAT-FSF-builds/releases/download/gnat-16.1.0-1/gnat-aarch64-darwin-16.1.0-1.tar.gz"
        sha256 "657cf254323eb91f79768918e8bd8887d6da7ac6056732a38f21e2848267da18"
      end
      on_intel do
        url "https://github.com/alire-project/GNAT-FSF-builds/releases/download/gnat-16.1.0-1/gnat-x86_64-darwin-16.1.0-1.tar.gz"
        sha256 "bb6d1434dc8850d7c6523eb455ab27f1f94eb760222c6c8acd540631e3f629bb"
      end
    end
    on_linux do
      on_arm do
        url "https://github.com/alire-project/GNAT-FSF-builds/releases/download/gnat-16.1.0-1/gnat-aarch64-linux-16.1.0-1.tar.gz"
        sha256 "8e297497f2d6d6845920a363a277b6ef5bc454e48a66d0d606b89d71e31ee623"
      end
      on_intel do
        url "https://github.com/alire-project/GNAT-FSF-builds/releases/download/gnat-16.1.0-1/gnat-x86_64-linux-16.1.0-1.tar.gz"
        sha256 "9f74f58a827a2ad40dd84c72a413e75ea52888e0d8f7e252fba4d26762402703"
      end
    end
  end

  deny_network_access!

  def install
    resource("bootstrap_gnat").stage do
      mkdir "#{buildpath}/gnat"
      `mv ./* #{buildpath}/gnat/`
      ENV["GNAT_BINARY_PATH"] = "#{buildpath}/gnat/bin"
    end

    ENV.prepend_path "PATH", ENV["GNAT_BINARY_PATH"]
    ENV["ADAC"] = "#{ENV["GNAT_BINARY_PATH"]}/gcc"

    inreplace "configure", /\${CC}(?= -c conftest\.adb)/, ENV["ADAC"]
    open("gcc/ada/gcc-interface/Make-lang.in", "a") { |f| f.puts "override CC = #{ENV["ADAC"]}" }

    # GCC will suffer build errors if forced to use a particular linker.
    ENV.delete "LD"

    pkgversion = "Homebrew GCC #{pkg_version}"

    # install the binaries into libexec as to not conflict with GCC
    # the relevant binaries are then exported later
    args = %W[
      --prefix=#{opt_prefix}
      --libdir=#{opt_lib}/gnat/current
      --bindir=#{opt_libexec}
      --disable-nls
      --enable-checking=release
      --with-gcc-major-version-only
      --enable-languages=c,ada
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

      ENV["ADAC"] = "#{ENV["ADAC"]} -mmacosx-version-min=#{OS.kernel_version.major}.0"

      sdk = MacOS.sdk_path
      args << "--with-sysroot=#{sdk}" if sdk

      # Avoid this semi-random failure:
      # "Error: Failed changing install name"
      # "Updated load commands do not fit in the header"
      make_args = %w[
        BOOT_LDFLAGS=-Wl,-headerpad_max_install_names
        LDFLAGS_FOR_TARGET=-Wl,-headerpad_max_install_names
      ]

      # no LDFLAGS from above are forwarded to the Ada build -> add it
      inreplace "gcc/ada/gcc-interface/Makefile.in",
            "$(GCC_FOR_ADA_RTS) -dynamiclib $(PICFLAG_FOR_TARGET) \\",
            "$(GCC_FOR_ADA_RTS) -dynamiclib $(PICFLAG_FOR_TARGET) -Wl,-headerpad_max_install_names \\"
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
      # See https://gcc.gnu.org/install/finalinstall.html
      # Also, the GNAT runtime should not be stripped,
      # as this would break certain features of the debugger
      # that depend on this debugging information (catching Ada exceptions for instance).
      system "../configure", *args
      system "make", *make_args
      system "make", "install", "DESTDIR=#{buildpath}/instdir"

      # the include files only contain C and C++ files
      # we do not need that and it would only create a conflict with gcc
      # the ada include files are in lib/gnat/current/gcc/<version>/<platform>/adainclude
      # e.g. lib/gnat/current/gcc/aarch64-apple-darwin27/16/adainclude/
      # -> simply remove it
      # Also remove man as it only contains things that conflict with GCC
      # As info would be deleted anyway, we just delete share entirely
      # For simplicity, we just leave out the things we do not need.
      # -> only need: libexec (which contains all bin) and lib
      libexec.install buildpath.glob("instdir/#{opt_libexec}/*")
      lib.install buildpath.glob("instdir/#{opt_lib}/*")
    end

    # we installed the binaries to libexec as to not cause a conflict with gcc
    # now expose (only) the gnat libraries
    gnatbins = libexec.glob("gnat*")
    gnatbins.each do |gnatexec|
      # do not just create symlinks, but use shell scripts
      # as gnat* will call gcc and we need to ensure it calls the correct one
      gnat_bin = File.basename(gnatexec)
      (bin/gnat_bin).write <<~GNAT_BIN
        #!/usr/bin/env sh
        PATH="#{libexec}/bin:$PATH" #{gnatexec} $*
      GNAT_BIN

      # install without version suffix (links to the newest version)
      bin.install_symlink bin/gnat_bin => bin/gnat_bin.delete_suffix("-#{version_suffix}")
    end

    # Provide a `lib/gnat/xy` directory to align with the versioned GCC formulae.
    # We need to create `lib/gnat/xy` as a directory and not a symlink to avoid `brew link` conflicts.
    (lib/"gnat"/version_suffix).install_symlink (lib/"gnat/current").children
  end

  def add_suffix(file, suffix)
    dir = File.dirname(file)
    ext = File.extname(file)
    base = File.basename(file, ext)
    File.rename file, "#{dir}/#{base}-#{suffix}#{ext}"
  end

  test do
    (testpath/"hello.adb").write <<~EOS
      with Text_IO; use Text_IO;
      procedure hello is
      begin
        Put_Line("Hello, world!");
      end hello;
    EOS
    system bin/"gnatmake", "hello.adb"
    assert_equal "Hello, world!\n", `./hello`
  end
end
