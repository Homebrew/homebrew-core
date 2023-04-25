class Aarch64ElfGdb < Formula
  desc "GNU debugger for aarch64-elf cross development"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-13.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-13.1.tar.xz"
  sha256 "115ad5c18d69a6be2ab15882d365dda2a2211c14f480b3502c6eba576e2e95a0"
  license "GPL-3.0-or-later"
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  livecheck do
    formula "gdb"
  end

  bottle do
    sha256 arm64_ventura:  "4c87c1677c2c04d7423f9caf06c9ce3edb259540bfb978df9a18a77354c2cba6"
    sha256 arm64_monterey: "a4e588e7a35203d448bf14b0369c4337640b699ae7363d81d73ae469b38cbbc5"
    sha256 arm64_big_sur:  "6c44025b0dd5016633b0848d91b2486957eca035b9f33252c6ffcdb0829f3a05"
    sha256 ventura:        "37739d6f6aae10d4af684060c13765afc327228e50fed8eeae832bb86db3f0c3"
    sha256 monterey:       "9a4c6368131cb5d8d6affd8205b9d79a7db4a2873aaf9ca6b4e7641debbe8f67"
    sha256 big_sur:        "27a8be044f81f96a7c42f24c106b2df4d0e455406545a569c2e4691a8de5d092"
    sha256 x86_64_linux:   "24b721fd59b732201a5d8cfd9b166af67f8220f5a3a564f1f7721e9663e185da"
  end

  depends_on "aarch64-elf-gcc" => :test
  depends_on "gmp"
  depends_on "python@3.11"
  depends_on "xz" # required for lzma support

  uses_from_macos "zlib"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    target = "aarch64-elf"
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
      --with-python=#{Formula["python@3.11"].opt_bin}/python3.11
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
    system "#{Formula["aarch64-elf-gcc"].bin}/aarch64-elf-gcc", "-g", "-nostdlib", "test.c"
    assert_match "Symbol \"_start\" is a function at address 0x",
          shell_output("#{bin}/aarch64-elf-gdb -batch -ex 'info address _start' a.out")
  end
end
