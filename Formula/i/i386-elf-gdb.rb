class I386ElfGdb < Formula
  desc "GNU debugger for i386-elf cross development"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-13.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-13.2.tar.xz"
  sha256 "fd5bebb7be1833abdb6e023c2f498a354498281df9d05523d8915babeb893f0a"
  license "GPL-3.0-or-later"
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  livecheck do
    formula "gdb"
  end

  bottle do
    sha256 arm64_sonoma:   "f4c20bc25441e6262599da91cc0a29d6e418e1fbf756b076515108b5f26b0cc4"
    sha256 arm64_ventura:  "4eb1c34b71bd7afca5f9cad406e537d7cc6fad33ad22af944e1ff4c043bd8ec4"
    sha256 arm64_monterey: "33b51337a454bae2df770cd8ac469b7fbb02df990ad30ebe76ec889e69f5f807"
    sha256 arm64_big_sur:  "20b224f9e4028261448a31a4d394148d3073c3c0a6b1807051702c02de476576"
    sha256 sonoma:         "710e0a7c6d4e70aaf102aef91eb7e9b52fcac4f3b86c34d847ab3dd1ed15203e"
    sha256 ventura:        "697ce9a486f71e618c6b3f6ee54e6a867aaff39e477cf444c9fcc8d0e8cba6a4"
    sha256 monterey:       "6f50fdfa82c77d6854fe20fa0fe85759bb2b0fd706e8489b6a4c99145da685ea"
    sha256 big_sur:        "faa7dd7ec9ddfe4e6d4bd54ee110ea0bde4cdf251fbcf9c246869f50a296741d"
    sha256 x86_64_linux:   "47271657a8539da8cb54edf83e90e312faedc73a7678c4762e9427a87395541e"
  end

  depends_on "i686-elf-gcc" => :test
  depends_on "gmp"
  depends_on "python@3.11"
  depends_on "xz" # required for lzma support

  uses_from_macos "zlib"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

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
      --with-python=#{Formula["python@3.11"].opt_bin}/python3.11
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
