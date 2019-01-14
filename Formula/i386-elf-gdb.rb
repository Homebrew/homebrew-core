class I386ElfGdb < Formula
  desc "GNU debugger for i386-elf cross development"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-8.2.tar.xz"
  sha256 "c3a441a29c7c89720b734e5a9c6289c0a06be7e0c76ef538f7bbcef389347c39"

  bottle do
    sha256 "744add2a9c9a8fb1fcc81b27d67c13f7cc41b0a739abba325ff26c0d88994142" => :mojave
    sha256 "d629eeb389a8913d26268b660bf27a41506a8aeff80b60af31fc2fa75ea4de15" => :high_sierra
    sha256 "20f65826d44b852b754715e293c3fd4fc1792acca5232e70760020e6d2cb8d4c" => :sierra
  end

  def install
    mkdir "build" do
      system "../configure", "--target=i386-elf",
                             "--prefix=#{prefix}",
                             "--disable-werror"
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/i386-elf-gdb", "#{bin}/i386-elf-gdb", "-configuration"
  end
end
