class I386ElfGdb < Formula
  desc "GNU debugger for i386-elf cross development"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-10.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-10.2.tar.xz"
  sha256 "aaa1223d534c9b700a8bec952d9748ee1977513f178727e1bee520ee000b4f29"
  license "GPL-3.0-or-later"
  head "https://sourceware.org/git/binutils-gdb.git"

  bottle do
    sha256 arm64_big_sur: "9e8043b364dbe987a46ad35437e986321c9d5999c62b853f1d474637521f09a9"
    sha256 big_sur:       "133541f91ae660943bc8790002c35032a0cb30b1480f806c65c3b66ec782f52e"
    sha256 catalina:      "4b529407dbdbb4a4686bf0c8e88511f6ec77cc24cd808704f457443d774ea7b7"
    sha256 mojave:        "7ffb645794a491ccc52fea225c511647ab3f39771e65c3a2912d0e77f7f4e181"
    sha256 high_sierra:   "f97095dfc0fc75cfdfa67f9cc8ef4402c7b8d4f24a0a522281f1d5c93c3ee4b3"
  end

  depends_on "i686-elf-gcc" => :test
  depends_on "python@3.9"
  depends_on "xz" # required for lzma support

  uses_from_macos "zlib"

  # Fix for https://sourceware.org/bugzilla/show_bug.cgi?id=26949#c8
  # Remove when upstream includes this commit
  # https://sourceware.org/git/gitweb.cgi?p=binutils-gdb.git;h=b413232211bf
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/242630de4b54d6c57721e12ce88988a0f4e41202/gdb/gdb-10.2.patch"
    sha256 "36652e9d97037266650a3b31f9f39539c4b376d31016fa4fc325dc0aa7930acc"
  end

  def install
    args = %W[
      --target=i386-elf
      --prefix=#{prefix}
      --datarootdir=#{share}/i386-elf-gdb
      --disable-debug
      --disable-dependency-tracking
      --with-lzma
      --with-python=#{Formula["python@3.9"].opt_bin}/python3
      --with-system-zlib
      --disable-binutils
    ]

    mkdir "build" do
      system "../configure", *args
      system "make"

      # Don't install bfd or opcodes, as they are provided by binutils
      system "make", "install-gdb"
    end

    mv include/"gdb", include/"i386-elf-gdb"
  end

  test do
    (testpath/"test.c").write "void _start(void) {}"
    system "#{Formula["i686-elf-gcc"].bin}/i686-elf-gcc", "-g", "-nostdlib", "test.c"
    assert_match "Symbol \"_start\" is a function at address 0x",
          shell_output("#{bin}/i386-elf-gdb -batch -ex 'info address _start' a.out")
  end
end
