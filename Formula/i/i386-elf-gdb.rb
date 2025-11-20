class I386ElfGdb < Formula
  desc "GNU debugger for i386-elf cross development"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftpmirror.gnu.org/gnu/gdb/gdb-16.3.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gdb/gdb-16.3.tar.xz"
  sha256 "bcfcd095528a987917acf9fff3f1672181694926cc18d609c99d0042c00224c5"
  license "GPL-3.0-or-later"
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  livecheck do
    formula "gdb"
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "00d034cdd538897b54a0ab0e9bd1adbdc0bcadd488b51612f430e239340eb48e"
    sha256 arm64_sequoia: "f1de96025601ca8294ffe433f6e2d45636c263436c658cd6701ca2c4bd152dc5"
    sha256 arm64_sonoma:  "49f0bef3eca6436eefbbaa12bff36f9f56a38f7d0cdc6bf89edf5f6143c92db0"
    sha256 sonoma:        "77b58e98df9c71a295ab4ff5ba70c3b581ed2e51c9aa35b19d4b08c86b94815d"
    sha256 arm64_linux:   "be334bd0a02c8ec268a854ae875915895aada6e6fefb97413ceb9484998e8e38"
    sha256 x86_64_linux:  "e4bcea3ae58286413f9b94e422582adc4cc16dec60e7d147409e1741efb03cf7"
  end

  depends_on "pkgconf" => :build
  depends_on "i686-elf-gcc" => :test
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "ncurses" # https://github.com/Homebrew/homebrew-core/issues/224294
  depends_on "python@3.14"
  depends_on "readline"
  depends_on "xz" # required for lzma support
  depends_on "zstd"

  uses_from_macos "expat", since: :sequoia # minimum macOS due to python
  uses_from_macos "zlib"

  # Workaround for https://github.com/Homebrew/brew/issues/19315
  on_sequoia :or_newer do
    on_intel do
      depends_on "expat"
    end
  end

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    target = "i386-elf"
    args = %W[
      --target=#{target}
      --datarootdir=#{share}/#{target}
      --includedir=#{include}/#{target}
      --infodir=#{info}/#{target}
      --mandir=#{man}
      --disable-binutils
      --disable-nls
      --enable-tui
      --with-curses
      --with-expat
      --with-lzma
      --with-python=#{which("python3.14")}
      --with-system-readline
      --with-system-zlib
      --with-zstd
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
    system Formula["i686-elf-gcc"].bin/"i686-elf-gcc", "-g", "-nostdlib", "test.c"

    output = shell_output("#{bin}/i386-elf-gdb -batch -ex 'info address _start' a.out")
    assert_match "Symbol \"_start\" is a function at address 0x", output
  end
end
