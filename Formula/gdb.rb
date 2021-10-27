class Gdb < Formula
  desc "GNU debugger"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-11.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-11.1.tar.xz"
  sha256 "cccfcc407b20d343fb320d4a9a2110776dd3165118ffd41f4b1b162340333f94"
  license "GPL-3.0-or-later"
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  bottle do
    sha256 monterey:     "c4d3d881ae2ae938b37031f94c9b2780e53f78fa224fe64532b08656157f9afe"
    sha256 big_sur:      "ce7aa7f3589b5833ff0ace1afb6e43ea01860666bf34ad7f941b9cab5c7ab5ab"
    sha256 catalina:     "7543956f666aae922d34accd371fbc57d901adb386776b47e079163933e75755"
    sha256 mojave:       "1d315c9b2213bfe09533c05beb2221a68ae816dc92c321d966c3fe1974e95913"
    sha256 x86_64_linux: "e83bcc7a2b903fb7e76b2d4b2ae2935d96100385a5cbae4316641c90fc724685"
  end

  depends_on "gmp"
  depends_on "python@3.9"
  depends_on "xz" # required for lzma support

  uses_from_macos "texinfo" => :build
  uses_from_macos "expat"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "gcc"
    depends_on "guile"
  end

  fails_with :clang do
    build 800
    cause <<~EOS
      probe.c:63:28: error: default initialization of an object of const type
      'const any_static_probe_ops' without a user-provided default constructor
    EOS
  end

  fails_with gcc: "5"

  def install
    args = %W[
      --enable-targets=all
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
      --with-lzma
      --with-python=#{Formula["python@3.9"].opt_bin}/python3
      --disable-binutils
    ]

    mkdir "build" do
      system "../configure", *args
      system "make"

      # Don't install bfd or opcodes, as they are provided by binutils
      system "make", "install-gdb", "maybe-install-gdbserver"
    end
  end

  def caveats
    <<~EOS
      gdb requires special privileges to access Mach ports.
      You will need to codesign the binary. For instructions, see:

        https://sourceware.org/gdb/wiki/PermissionsDarwin
    EOS
  end

  test do
    system bin/"gdb", bin/"gdb", "-configuration"
  end
end
