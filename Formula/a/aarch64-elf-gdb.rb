class Aarch64ElfGdb < Formula
  desc "GNU debugger for aarch64-elf cross development"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-14.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-14.1.tar.xz"
  sha256 "d66df51276143451fcbff464cc8723d68f1e9df45a6a2d5635a54e71643edb80"
  license "GPL-3.0-or-later"
  revision 1
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  livecheck do
    formula "gdb"
  end

  bottle do
    sha256 arm64_sonoma:   "df4e779ee6107bc8643ad6df92c7f4573fe5b186b89b364404c43c260f74ed9c"
    sha256 arm64_ventura:  "5cc6e55cabd06936805e085be2311a9717d80cda95cb981434833f6b0ede66f7"
    sha256 arm64_monterey: "3b5955a2356aebc797acac5bfd4764b8d8caab869933a78e69170444bf52799f"
    sha256 sonoma:         "2f6e00a0ee61bfe4e7efd9f335cc3754740d593459577d26f004dabf46942c70"
    sha256 ventura:        "24876c95a6ba28dc6c597a883ae986adc860cd8ad69815532c9aafb17f97cd42"
    sha256 monterey:       "d4c3a0c287c3e745e6a5fadb73a42feaf3cb892d1dce39acd6447052b85e1ad3"
    sha256 x86_64_linux:   "1cdcd7ee4055d0fe50b91164c408de41e8958c68c894b5eab221b38625c5d476"
  end

  depends_on "pkg-config" => :build
  depends_on "aarch64-elf-gcc" => :test
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "python@3.12"
  depends_on "readline"
  depends_on "xz" # required for lzma support
  depends_on "zstd"

  uses_from_macos "expat"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    target = "aarch64-elf"
    args = %W[
      --target=#{target}
      --datarootdir=#{share}/#{target}
      --includedir=#{include}/#{target}
      --infodir=#{info}/#{target}
      --mandir=#{man}
      --enable-tui
      --with-curses
      --with-expat
      --with-lzma
      --with-python=#{which("python3.12")}
      --with-system-readline
      --with-system-zlib
      --with-zstd
      --disable-binutils
      --disable-nls
    ]

    mkdir "build" do
      system "../configure", *args, *std_configure_args
      ENV.deparallelize # Error: common/version.c-stamp.tmp: No such file or directory
      system "make"

      # Don't install bfd or opcodes, as they are provided by binutils
      system "make", "install-gdb"
    end
  end

  test do
    (testpath/"test.c").write "void _start(void) {}"
    system "#{Formula["aarch64-elf-gcc"].bin}/aarch64-elf-gcc", "-g", "-nostdlib", "test.c"
    assert_match "Symbol \"_start\" is a function at address 0x",
          shell_output("#{bin}/aarch64-elf-gdb -batch -ex 'info address _start' a.out")
  end
end
