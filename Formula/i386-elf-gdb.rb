class I386ElfGdb < Formula
  desc "GNU debugger for i386-elf cross development"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-12.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-12.1.tar.xz"
  sha256 "0e1793bf8f2b54d53f46dea84ccfd446f48f81b297b28c4f7fc017b818d69fed"
  license "GPL-3.0-or-later"
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  livecheck do
    formula "gdb"
  end

  bottle do
    sha256 arm64_monterey: "28446027067f4c4beba9db4fdb282da2b92b61b52a167b9258b44d3ff822d6a9"
    sha256 arm64_big_sur:  "6ed21bdc62c33e8774d438928a37dbf6f6543707b39a396bb5dcba64b1f07669"
    sha256 monterey:       "53afd744fcb91a0ba17d52a4cf3628bc84756663db3d7b9fd81192bf90a5ba3e"
    sha256 big_sur:        "0848d18425249ff040691b2f247f8ffdece645c13a4402c51ebbf88cadd1f61f"
    sha256 catalina:       "ed282f08f2c53276c4d105cf3c20e74a688b226aced2d1c01e52e73c80d18e58"
    sha256 x86_64_linux:   "59f4d6fdc7ec138da1755acd059b3930ac670c29a8ff27ac32d29adc5c66f1be"
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
