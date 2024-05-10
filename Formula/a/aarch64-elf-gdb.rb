class Aarch64ElfGdb < Formula
  desc "GNU debugger for aarch64-elf cross development"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-14.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-14.2.tar.xz"
  sha256 "2d4dd8061d8ded12b6c63f55e45344881e8226105f4d2a9b234040efa5ce7772"
  license "GPL-3.0-or-later"
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  livecheck do
    formula "gdb"
  end

  bottle do
    sha256 arm64_sonoma:   "e0fe06ddf01e98f9f3b1bacbacdfeb8e94c69fed9ed296adb3237014dc5d388d"
    sha256 arm64_ventura:  "3e8a6f8721ae7f70b4d7c9bc24f75674604bc3985e829fa90f4d8f89493b9eee"
    sha256 arm64_monterey: "be4fb136fe3c6be6096cdb2712da166fb9d9217ff5b294859acbaa362840ed88"
    sha256 sonoma:         "5e56fc21982e0c9b493e51847f55e268693e1a381dbfb1ae761fd3cd1dbef26f"
    sha256 ventura:        "8f151a4fbf9185320e6d8ce79e0fba4e856b2286364c3ece369f766549f2750e"
    sha256 monterey:       "299757fa86eee8576b7bda5c0822836dfbaa4e9049e98fa96df58c20e99b751a"
    sha256 x86_64_linux:   "afe17d09b65783e472a0c8410a0204f40467b762c0f6156b680a4bf659228334"
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
