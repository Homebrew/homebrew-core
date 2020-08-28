class I386ElfGdb < Formula
  desc "GNU debugger for i386-elf cross development"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-9.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-9.2.tar.xz"
  sha256 "360cd7ae79b776988e89d8f9a01c985d0b1fa21c767a4295e5f88cb49175c555"
  license "GPL-2.0"
  head "https://sourceware.org/git/binutils-gdb.git"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "8d6ce6e01f67563076e657967c64aa266b7b6d93fd9ffe7cc0f91cb38d4f700f" => :catalina
    sha256 "2a8ecb8ae77565fabfb6286fbc60f4aaf843bc74c72b3ff2e1d5087e4dcbd92e" => :mojave
    sha256 "8dad06d6eea6ec145763819d982916d590edd45b40e4c91e328bba76f0aac0bf" => :high_sierra
  end

  depends_on "python@3.8"
  depends_on "xz" # required for lzma support

  conflicts_with "gdb", because: "both install include/gdb, share/gdb and share/info"

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
