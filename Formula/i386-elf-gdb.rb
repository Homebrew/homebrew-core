class I386ElfGdb < Formula
  desc "GNU debugger for i386-elf cross development"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-10.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-10.1.tar.xz"
  sha256 "f82f1eceeec14a3afa2de8d9b0d3c91d5a3820e23e0a01bbb70ef9f0276b62c0"
  license "GPL-3.0-or-later"
  head "https://sourceware.org/git/binutils-gdb.git"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "133541f91ae660943bc8790002c35032a0cb30b1480f806c65c3b66ec782f52e" => :big_sur
    sha256 "9e8043b364dbe987a46ad35437e986321c9d5999c62b853f1d474637521f09a9" => :arm64_big_sur
    sha256 "4b529407dbdbb4a4686bf0c8e88511f6ec77cc24cd808704f457443d774ea7b7" => :catalina
    sha256 "7ffb645794a491ccc52fea225c511647ab3f39771e65c3a2912d0e77f7f4e181" => :mojave
    sha256 "f97095dfc0fc75cfdfa67f9cc8ef4402c7b8d4f24a0a522281f1d5c93c3ee4b3" => :high_sierra
  end

  depends_on "python@3.9"
  depends_on "xz" # required for lzma support

  conflicts_with "gdb", because: "both install include/gdb, share/gdb and share/info"
  conflicts_with "x86_64-elf-gdb", because: "both install include/gdb, share/gdb and share/info"

  def install
    args = %W[
      --target=i386-elf
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
      --with-lzma
      --with-python=#{Formula["python@3.9"].opt_bin}/python3
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
