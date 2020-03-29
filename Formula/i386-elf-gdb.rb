class I386ElfGdb < Formula
  desc "GNU debugger for i386-elf cross development"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-9.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-9.1.tar.xz"
  sha256 "699e0ec832fdd2f21c8266171ea5bf44024bd05164fdf064e4d10cc4cf0d1737"
  head "https://sourceware.org/git/binutils-gdb.git"

  bottle do
    rebuild 1
    sha256 "43be10af58f9520fcac979bcab1895caa4db95b6421e3446a0384dd1993ebb6f" => :catalina
    sha256 "1e0f6eadbf426a5d1806745d19a09dfb1afdcdcb9c8979b4812b147287e43ebb" => :mojave
    sha256 "320e9a47b260f302a8cf44fa012595e9a5404327d8371ab7d2b3b4797d4dbf09" => :high_sierra
  end

  depends_on "python@3.8"
  depends_on "xz" # required for lzma support

  conflicts_with "gdb", :because => "both install include/gdb, share/gdb and share/info"

  def install
    args = %W[
      --target=i386-elf
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
      --with-lzma
      --with-python=#{Formula["python@3.8"].opt_bin}/python3
      --disable-binutils
    ]

    mkdir "build" do
      system "../configure", *args
      system "make"

      # Don't install bfd or opcodes, as they are provided by binutils
      system "make", "install-gdb"
    end
  end

  test do
    system "#{bin}/i386-elf-gdb", "#{bin}/i386-elf-gdb", "-configuration"
  end
end
