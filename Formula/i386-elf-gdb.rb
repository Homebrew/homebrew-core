class I386ElfGdb < Formula
  desc "GNU debugger for i386-elf cross development"
  homepage "https://www.gnu.org/software/gdb/"
  # Please add to synced_versions_formulae.json once version synced with gdb
  url "https://ftp.gnu.org/gnu/gdb/gdb-11.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-11.2.tar.xz"
  sha256 "1497c36a71881b8671a9a84a0ee40faab788ca30d7ba19d8463c3cc787152e32"
  license "GPL-3.0-or-later"
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  livecheck do
    formula "gdb"
  end

  bottle do
    sha256 arm64_monterey: "6db8c02704d1836ef16f46769f7ca6c49422876b81c144ce781481da0a9ec629"
    sha256 arm64_big_sur:  "51349a449a0d4e32f06acbf5516fea00444a189a41812303e0317a831d1bee30"
    sha256 monterey:       "3d121bee077b2fab236f9b73795407fef99238804db1fd1a3bd8fb24dcab3497"
    sha256 big_sur:        "c2e085712bd764ceea43c583c6bc44351e61a06385bc2cf64a6ea337f583fb05"
    sha256 catalina:       "8309db4002952af3b1334101ad227e1b0328413dc6b04cf252596c6245690829"
    sha256 x86_64_linux:   "f84b25344a2e3e0508bb642988da76cbd57521c3a834d814654e637e9b703d84"
  end

  depends_on "i686-elf-gcc" => :test
  depends_on "gmp"
  depends_on "python@3.10"
  depends_on "xz" # required for lzma support

  uses_from_macos "texinfo" => :build
  uses_from_macos "zlib"

  def install
    target = "i386-elf"
    args = %W[
      --target=#{target}
      --prefix=#{prefix}
      --datarootdir=#{share}/#{target}
      --includedir=#{include}/#{target}
      --infodir=#{info}/#{target}
      --mandir=#{man}
      --disable-debug
      --disable-dependency-tracking
      --with-lzma
      --with-python=#{Formula["python@3.10"].opt_bin}/python3
      --with-system-zlib
      --disable-binutils
    ]

    mkdir "build" do
      system "../configure", *args
      ENV.deparallelize # Error: common/version.c-stamp.tmp: No such file or directory
      system "make"

      # Don't install bfd or opcodes, as they are provided by binutils
      system "make", "install-gdb"
    end
  end

  test do
    (testpath/"test.c").write "void _start(void) {}"
    system Formula["i686-elf-gcc"].bin/"i686-elf-gcc", "-g", "-nostdlib", "test.c"
    assert_match "Symbol \"_start\" is a function at address 0x",
                 shell_output("#{bin}/i386-elf-gdb -batch -ex 'info address _start' a.out")
  end
end
