class I386ElfGdb < Formula
  desc "GNU debugger for i386-elf cross development"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-9.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-9.1.tar.xz"
  sha256 "699e0ec832fdd2f21c8266171ea5bf44024bd05164fdf064e4d10cc4cf0d1737"
  head "https://sourceware.org/git/binutils-gdb.git"

  bottle do
    sha256 "78bc76a038e82c274fcbf1acb1a731d3e93e137501f2e93578998f2ad3d69707" => :catalina
    sha256 "bdecb45d09a045fe1ffaa9e489ca5d5cf4bc52ad317066ddebcc6fef762214b0" => :mojave
    sha256 "f24d032ddfe38c469592fcd27de1f2cd76748065291003802f63ed2eeefc0802" => :high_sierra
    sha256 "db2569c5307b05e3806d5fe4072782b8f9601abe60779144b66a45c1fe6abc8b" => :sierra
  end

  def install
    mkdir "build" do
      system "../configure", "--target=i386-elf",
                             "--prefix=#{prefix}",
                             "--disable-werror"
      system "make"

      # Don't install bfd or opcodes, as they are provided by binutils
      system "make", "install-gdb"
    end
  end

  test do
    system "#{bin}/i386-elf-gdb", "#{bin}/i386-elf-gdb", "-configuration"
  end
end
