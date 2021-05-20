class Gnat < Formula
  desc "GNU New York University Ada Trans"
  homepage "https://gcc.gnu.org/"
  url "https://ftp.gnu.org/gnu/gcc/gcc-11.1.0/gcc-11.1.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-11.1.0/gcc-11.1.0.tar.xz"
  sha256 "4c4a6fb8a8396059241c2e674b85b351c26a5d678274007f076957afa1cc9ddf"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }
  head "https://gcc.gnu.org/git/gcc.git"

  livecheck do
    url "https://ftp.gnu.org/gnu/gcc/gcc-11.1.0"
    regex(%r{href=.*?gcc[._-]v?(\d+(?:\.\d+)+)(?:/?["' >]|\.t)}i)
  end

  # The bottles are built on systems with the CLT installed, and do not work
  # out of the box on Xcode-only systems due to an incorrect sysroot.
  pour_bottle? only_if: :clt_installed

  depends_on arch: :x86_64

  depends_on "gmp"
  depends_on "isl"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "zstd"

  uses_from_macos "libiconv"
  uses_from_macos "zlib"

  on_linux do
    depends_on "binutils"
  end

  conflicts_with "gcc", because: "both install gcc"

  # GCC bootstraps itself, so it is OK to have an incompatible C++ stdlib
  cxxstdlib_check :skip

  def version_suffix
    if build.head?
      "HEAD"
    else
      version.major.to_s
    end
  end

  resource "bootstrap_gcc" do
    url "https://phoenixnap.dl.sourceforge.net/project/gnuada/GNAT_GCC%20Mac%20OS%20X/11.1.0/native/gcc-11.1.0-x86_64-apple-darwin15.pkg"
    sha256 "d947b5db0576cb62942e5ce61f3ef53fb679f07b1adff7a4c0fa19a5e72a9532"
  end

  def install
    resource("bootstrap_gcc").stage do
      system "pkgutil", "--expand-full", "gcc-11.1.0-x86_64-apple-darwin15.pkg", buildpath/"bootstrap_gcc"
    end
    bootstrap_gcc_prefix = buildpath/"bootstrap_gcc/gcc-11.1.0-x86_64-apple-darwin15.pkg/Payload"
    inreplace "configure", /\${CC}(?= -c conftest\.adb)/, bootstrap_gcc_prefix/"bin/gcc"
    open("gcc/ada/gcc-interface/Make-lang.in", "a") { |f| f.puts "override CC = #{bootstrap_gcc_prefix}/bin/gcc" }

    ENV.append_path "PATH", bootstrap_gcc_prefix/"bin"
    ENV["ADAC"] = bootstrap_gcc_prefix/"bin/gcc"

    # GCC will suffer build errors if forced to use a particular linker.
    ENV.delete "LD"

    pkgversion = "Homebrew GCC #{pkg_version} #{build.used_options*" "}".strip
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"

    args = %W[
      --prefix=#{prefix}
      --libdir=#{lib}/gcc/#{version_suffix}
      --disable-nls
      --enable-checking=release
      --enable-languages=c,ada
      --program-suffix=-#{version_suffix}
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

    on_macos do
      args << "--build=#{cpu}-apple-darwin#{OS.kernel_version.major}"
      args << "--with-system-zlib"

      # Xcode 10 dropped 32-bit support
      args << "--disable-multilib" if DevelopmentTools.clang_build_version >= 1000

      # Workaround for Xcode 12.5 bug on Intel
      # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=100340
      args << "--without-build-config" if Hardware::CPU.intel? && DevelopmentTools.clang_build_version >= 1205

      # System headers may not be in /usr/include
      sdk = MacOS.sdk_path_if_needed
      if sdk
        args << "--with-native-system-header-dir=/usr/include"
        args << "--with-sysroot=#{sdk}"
        ENV["SDKROOT"] = MacOS.sdk_path
      end

      # Ensure correct install names when linking against libgcc_s;
      # see discussion in https://github.com/Homebrew/legacy-homebrew/pull/34303
      inreplace "libgcc/config/t-slibgcc-darwin", "@shlib_slibdir@", "#{HOMEBREW_PREFIX}/lib/gcc/#{version_suffix}"
    end

    mkdir "build" do
      system "../configure", *args

      # Use -headerpad_max_install_names in the build,
      # otherwise updated load commands won't fit in the Mach-O header.
      # This is needed because `gcc` avoids the superenv shim.
      system "make", "BOOT_LDFLAGS=-Wl,-headerpad_max_install_names"
      system "make", "install"

      Pathname.glob(bin/"gnat*") do |b|
        bin.install_symlink b => b.stem.chomp("-#{version_suffix}")
      end
    end

    # Handle conflicts between GCC formulae and avoid interfering
    # with system compilers.
    # Rename man7.
    Dir.glob(man7/"*.7") { |file| add_suffix file, version_suffix }
    # Even when we disable building info pages some are still installed.
    info.rmtree
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
    system bin/"gnatmake", "--GCC=gcc-#{version_suffix}",
      "--GNATLINK=gnatlink --GCC=gcc-#{version_suffix}", "hello.adb"
    assert_equal "Hello, world!\n", `./hello`
  end
end
