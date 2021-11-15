class I386ElfGdb < Formula
  desc "GNU debugger for i386-elf cross development"
  homepage "https://www.gnu.org/software/gdb/"
  # Please add to synced_versions_formulae.json once version synced with gdb
  url "https://ftp.gnu.org/gnu/gdb/gdb-10.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-10.2.tar.xz"
  sha256 "aaa1223d534c9b700a8bec952d9748ee1977513f178727e1bee520ee000b4f29"
  license "GPL-3.0-or-later"
  revision 1
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  livecheck do
    formula "gdb"
  end

  bottle do
    sha256 arm64_monterey: "5bbec8b43413d033bf75a123959476b515bf13f1a66af58032634aba5d5b2757"
    sha256 arm64_big_sur:  "b4c91d248b5ba7d765c277903ac03f1f3d35a77079ae3acbdba8768a9dcb4c55"
    sha256 monterey:       "21b133542f15adac54a0b2b55e7da2ffd584396b1fcd771864742f3811db784a"
    sha256 big_sur:        "dbf60ac8e71d01328d134cb1eaa47cd734dd612cd67cc7b730d56afc138ea969"
    sha256 catalina:       "4ca5521aab0566367e9a72767225d08667efb40e609c0b8e9e4ff7464f755052"
    sha256 mojave:         "85a64a23e61b011e32cff2c56e7915f32a8d8d669be09e4698b431412e8ea7b0"
    sha256 x86_64_linux:   "919e6534fce532ad0395fe4fd756004e3ebe25fd653aff1df825455b68643f7c"
  end

  depends_on "i686-elf-gcc" => :test
  depends_on "python@3.9"
  depends_on "xz" # required for lzma support

  uses_from_macos "texinfo" => :build
  uses_from_macos "zlib"

  # Fix for https://sourceware.org/bugzilla/show_bug.cgi?id=26949#c8
  # Remove when upstream includes this commit
  # https://sourceware.org/git/gitweb.cgi?p=binutils-gdb.git;h=b413232211bf
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/242630de4b54d6c57721e12ce88988a0f4e41202/gdb/gdb-10.2.patch"
    sha256 "36652e9d97037266650a3b31f9f39539c4b376d31016fa4fc325dc0aa7930acc"
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
  end

  test do
    (testpath/"test.c").write "void _start(void) {}"
    system Formula["i686-elf-gcc"].bin/"i686-elf-gcc", "-g", "-nostdlib", "test.c"
    assert_match "Symbol \"_start\" is a function at address 0x",
                 shell_output("#{bin}/i386-elf-gdb -batch -ex 'info address _start' a.out")
  end
end
