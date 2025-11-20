class ArmNoneEabiGdb < Formula
  desc "GNU debugger for arm-none-eabi cross development"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftpmirror.gnu.org/gnu/gdb/gdb-16.3.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gdb/gdb-16.3.tar.xz"
  sha256 "bcfcd095528a987917acf9fff3f1672181694926cc18d609c99d0042c00224c5"
  license "GPL-3.0-or-later"
  revision 1
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  livecheck do
    formula "gdb"
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "c2740373076acc200aa0157c156004d5e7a87276a38eef9c363ea2cdeb577f64"
    sha256 arm64_sequoia: "f27a61727c7a0c34b9b5656173db8c49b9fbbd78b902644bbdbd1a6ebb32423c"
    sha256 arm64_sonoma:  "b018d62e0c9398b4a04d4e046b6cea110eab0c162f3fe888226cd627f156b68d"
    sha256 sonoma:        "995c4e02b1c766c51e5fa1b864c3194977617fa0830ce4fec42db7ba83878740"
    sha256 arm64_linux:   "a3ee4b947887ee5c53f3e183c9267928a998784befad772a322baf7780f8c2ee"
    sha256 x86_64_linux:  "0ecf24fbf0edc3dfe36e401357494e031a88f2457a44cce5a81c2bdc513dc1ce"
  end

  depends_on "pkgconf" => :build
  depends_on "arm-none-eabi-gcc" => :test
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
    system "#{Formula["arm-none-eabi-gcc"].bin}/arm-none-eabi-gcc", "-g", "-nostdlib", "test.c"
    assert_match "Symbol \"_start\" is a function at address 0x",
          shell_output("#{bin}/arm-none-eabi-gdb -batch -ex 'info address _start' a.out")
  end
end
