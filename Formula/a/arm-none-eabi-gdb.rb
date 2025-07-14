class ArmNoneEabiGdb < Formula
  desc "GNU debugger for arm-none-eabi cross development"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-16.3.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-16.3.tar.xz"
  sha256 "bcfcd095528a987917acf9fff3f1672181694926cc18d609c99d0042c00224c5"
  license "GPL-3.0-or-later"
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  livecheck do
    formula "gdb"
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "1a7301cc72a0e20ca3210b0a039226319eaa33259670ef53d9f2fe57a3ad91ef"
    sha256 arm64_sonoma:  "e3f460c763a63f70e0b3f93a9763638a3e2a358e561d3216d102cabea65cebb5"
    sha256 arm64_ventura: "185b464524777e63901da56fb727d6ae6c3b1d776213294d330ca7ffa8c0b55f"
    sha256 sonoma:        "0768015caa13cddc4e56cfa265e396bef30e786d052417d530595f6965fc6e13"
    sha256 ventura:       "bafd4327eaf7943a9b11d28e9d99699245b8e1ff2302db8474a4466142446b15"
    sha256 arm64_linux:   "2866df5b2c8bb8e5d8a7ee04b407cca220877c0494004cda4e35bb17af9b4069"
    sha256 x86_64_linux:  "50f19c339ae4ea0e2e15300ef4d1720f3550c99cffe4ed4f9b3302a543e34d97"
  end

  depends_on "pkgconf" => :build
  depends_on "arm-none-eabi-gcc" => :test
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "ncurses" # https://github.com/Homebrew/homebrew-core/issues/224294
  depends_on "python@3.13"
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
    target = "arm-none-eabi"
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
      --with-python=#{which("python3.13")}
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
    system "#{Formula["arm-none-eabi-gcc"].bin}/arm-none-eabi-gcc", "-g", "-nostdlib", "test.c"
    assert_match "Symbol \"_start\" is a function at address 0x",
          shell_output("#{bin}/arm-none-eabi-gdb -batch -ex 'info address _start' a.out")
  end
end
