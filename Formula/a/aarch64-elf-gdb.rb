class Aarch64ElfGdb < Formula
  desc "GNU debugger for aarch64-elf cross development"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-15.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-15.2.tar.xz"
  sha256 "83350ccd35b5b5a0cba6b334c41294ea968158c573940904f00b92f76345314d"
  license "GPL-3.0-or-later"
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  livecheck do
    formula "gdb"
  end

  bottle do
    sha256 arm64_sequoia: "b62673061d0dc0e43854dc03f881a8c1c862a49c083bddbe4f92e851bdb29eae"
    sha256 arm64_sonoma:  "8a7fb61f0c58aaec08d9d4a7af0d2e85d4137da492bdfdbd4d4b0a4572e9be43"
    sha256 arm64_ventura: "83f82a565e83ce1b601c1dcd08a095ff4c6a60045d4d6deae16ca8fa63574beb"
    sha256 sonoma:        "f09b8ba93f91471910fcd70c481137b28990e33d2f062a300692965b9bfbc5de"
    sha256 ventura:       "afb225d0c2c19acac114fe52f776256510d9ae3352c5cdc5707facb6eeffa259"
    sha256 x86_64_linux:  "20b07a8f2ead7c91287fc52b063746f1e733554075133959819bf48ed78aea06"
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
