class Aarch64ElfGdb < Formula
  desc "GNU debugger for aarch64-elf cross development"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-13.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-13.2.tar.xz"
  sha256 "fd5bebb7be1833abdb6e023c2f498a354498281df9d05523d8915babeb893f0a"
  license "GPL-3.0-or-later"
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  livecheck do
    formula "gdb"
  end

  bottle do
    sha256 arm64_ventura:  "b1efda07dd935af505f521904384bf36e34985037baad7190114026d1f5b7e75"
    sha256 arm64_monterey: "c7eb740063212c35f576edb8da4872c71599494d5955298f0b6c5307e0b3fbca"
    sha256 arm64_big_sur:  "a17cc6ab305fb77ad7764895eef888172bcd3dfd07c90e6bfa79aaf832958c06"
    sha256 ventura:        "b4a73241baeaf7a6857c126578baa0eb2ce5d0f46fc3cac2a3981ba6ab50b193"
    sha256 monterey:       "c3b55ff017d18a3dd0a8f8876ec73958659daa8b28b6b77ff576077dda64d414"
    sha256 big_sur:        "31ac4b41ec94970f6ccde66d73c7a293a1b735e940e361da630d1ec9170757f1"
    sha256 x86_64_linux:   "4e32ff069f804c1ca8042dac7f2b6d3c8f5105a531ddf1fff6e0862c9e9bfdbc"
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
