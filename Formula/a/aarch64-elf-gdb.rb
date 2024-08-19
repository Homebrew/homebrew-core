class Aarch64ElfGdb < Formula
  desc "GNU debugger for aarch64-elf cross development"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-15.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-15.1.tar.xz"
  sha256 "38254eacd4572134bca9c5a5aa4d4ca564cbbd30c369d881f733fb6b903354f2"
  license "GPL-3.0-or-later"
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  livecheck do
    formula "gdb"
  end

  bottle do
    sha256 arm64_sonoma:   "63d6a5d5caefd0c4e4a5c07986638a0178b8659caaa9c0aa4587c979a9049bb9"
    sha256 arm64_ventura:  "4259b476ca52a7cfe17ad36a1251de44916aa4a6c2fcbebf7955ecd2b1807d07"
    sha256 arm64_monterey: "57b2407f5fe9d0f6409121e2029ea5062f349dab3b19b85cbdd25d368ddc5956"
    sha256 sonoma:         "348be178426a897da684e0fa7e6661068b0d9be39250d4245f34fa1f8e23b56b"
    sha256 ventura:        "cc514ebf544c3e5678b3d076ac2622d1d2dc96b8f8243e6a821e240be187a21a"
    sha256 monterey:       "9b6764be2914e8303caa58461bceb44dbd47842927cb3ff06456f28c5ec940b7"
    sha256 x86_64_linux:   "393ec8e3717b1abf6fd13cc593b076697c41f6d3fe5f173051116ed119f19538"
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
