class I386ElfGdb < Formula
  desc "GNU debugger for i386-elf cross development"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-16.3.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-16.3.tar.xz"
  sha256 "bcfcd095528a987917acf9fff3f1672181694926cc18d609c99d0042c00224c5"
  license "GPL-3.0-or-later"
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  livecheck do
    formula "gdb"
  end

  bottle do
    sha256 arm64_sequoia: "af939496c6245db5f2f812e196fb9e4b3623f15a2db5035716f392d6633ffe8c"
    sha256 arm64_sonoma:  "951dac8073ae7de6fb7d74db8b7694a4bc323e02013f1ac541b1f03f45e8d319"
    sha256 arm64_ventura: "b8c97775ea52dfbb3459fae62aa433402a2fb23a1d3b4553be7c206b38e63701"
    sha256 sonoma:        "a7a43697ffade75a422458eb851588a15b042272729d9850339ae465069cd5cf"
    sha256 ventura:       "c9d550dcb8ddb0db49e41f7a72339424e320ee23537ed52e8f66b2887185d889"
    sha256 arm64_linux:   "2a7f9f61e3f2faac56dfd439e1488567643896454a98acf4d03fa7e201a6d57f"
    sha256 x86_64_linux:  "3f2f5cd65a663532604928725a87b015fd9f596ae92b647a4ee6b4fb9c61fd97"
  end

  depends_on "i686-elf-gcc" => :test
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "python@3.13"
  depends_on "xz" # required for lzma support

  uses_from_macos "expat", since: :sequoia # minimum macOS due to python
  uses_from_macos "ncurses"
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
      --with-lzma
      --with-python=#{which("python3.13")}
      --with-system-zlib
      --disable-binutils
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
