class I386ElfGdb < Formula
  desc "GNU debugger for i386-elf cross development"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-8.3.tar.xz"
  sha256 "802f7ee309dcc547d65a68d61ebd6526762d26c3051f52caebe2189ac1ffd72e"

  bottle do
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
