class I386ElfGdb < Formula
  desc "GNU debugger for i386-elf cross development"
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
    sha256 arm64_sequoia: "be8a2a2f0f18a53349a0f6103a4ef0859768f7ab41e5c2c52d604b2429ed8039"
    sha256 arm64_sonoma:  "6070a72caa2528c08bff3f308faa1bb181e106415a7fda814b88b3d9dc068943"
    sha256 arm64_ventura: "516c2c1674652d852968a86967e603fecca37b0c011f9e41c3b53d1289964585"
    sha256 sonoma:        "f42540c98d2ecd220c569272d1f0dce591f38fde394c70bf7b5ea513ea78144c"
    sha256 ventura:       "c524423fa98380fcb953e7ef6bc539f1822dc1c36e9a6706997515877121f66c"
    sha256 x86_64_linux:  "1167a22ec9850be75bf301911ceb7250f0964e491a92fd50d50d2896d517c783"
  end

  depends_on "i686-elf-gcc" => :test
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "python@3.12"
  depends_on "xz" # required for lzma support

  uses_from_macos "expat"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

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
      --with-python=#{which("python3.12")}
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
