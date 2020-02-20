class I386ElfGdb < Formula
  desc "GNU debugger for i386-elf cross development"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-9.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-9.1.tar.xz"
  sha256 "699e0ec832fdd2f21c8266171ea5bf44024bd05164fdf064e4d10cc4cf0d1737"
  head "https://sourceware.org/git/binutils-gdb.git"

  bottle do
    sha256 "8b58be6c0e44cf7b180e7729c47a726ea4e268115f1a77dc24adee9f6963e482" => :catalina
    sha256 "92cdbf67b36efd307633153414220dd4dbdc732a26e87a19c05f8dbf72d30b3a" => :mojave
    sha256 "5a173cea39b163dabfd97db3ea26446344ff82bdc3792b3111414d7f5c9ee6de" => :high_sierra
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
