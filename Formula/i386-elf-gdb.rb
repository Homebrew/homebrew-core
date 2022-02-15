class I386ElfGdb < Formula
  desc "GNU debugger for i386-elf cross development"
  homepage "https://www.gnu.org/software/gdb/"
  # Please add to synced_versions_formulae.json once version synced with gdb
  url "https://ftp.gnu.org/gnu/gdb/gdb-11.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-11.2.tar.xz"
  sha256 "1497c36a71881b8671a9a84a0ee40faab788ca30d7ba19d8463c3cc787152e32"
  license "GPL-3.0-or-later"
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  livecheck do
    formula "gdb"
  end

  bottle do
    sha256 arm64_monterey: "ea7d902a723c95cb18fe55d53c034cc245b663be9591fbc69139ce8c8b7382b0"
    sha256 arm64_big_sur:  "d943e7587d70a3e6a6c58e72688a5b302b8346abd95376ed50a69612fc1b503e"
    sha256 monterey:       "97989e0669664911ab1b563476d3b1e7094456c98b222c4ad54c7a51e25a34cc"
    sha256 big_sur:        "995a23f630c40101c11ad55d4f2b002398f282ea05934630acd4343a9a1aa407"
    sha256 catalina:       "ce22008756d411fbe5f3a4727e157ac7b4fb413f175b2da07793385f884f8cc7"
    sha256 x86_64_linux:   "de8f9b0dc7709e23f693fc38567e80e6b90b5bf3dd81d033e9580baabcaa96a3"
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
