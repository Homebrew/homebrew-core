class I686ElfBinutils < Formula
  desc "GNU Binutils for i686-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.46.0.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.46.0.tar.bz2"
  sha256 "0f3152632a2a9ce066f20963e9bb40af7cf85b9b6c409ed892fd0676e84ecd12"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_tahoe:   "87db49adee329e93df84eca55a4ff3f6fadf3a89e3ed3c18121d306165fdf148"
    sha256 arm64_sequoia: "faefb092ac8e2fec628f74a5000c921538be37dc0bdcd410d072ce68db60d89b"
    sha256 arm64_sonoma:  "42ff6dc6f62429f01c7b2285aac6411509b12d5c166dbb84b5be60697bd61315"
    sha256 sonoma:        "2a590a39a38f43d4e102d994d0c0b8597e0760ec5efeb1f04b4a93e0c97e2994"
    sha256 arm64_linux:   "d9faaa4252d154dd14f32457aded90c2ccf5138be6049eb64d4421eff08fc5b6"
    sha256 x86_64_linux:  "c9c3b79f8a3cf007aef14725df7f8c2ba8544bd251b3fd7f3d3ec1e289545b2e"
  end

  depends_on "pkgconf" => :build
  depends_on "zstd"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    target = "i686-elf"
    system "./configure", "--target=#{target}",
                          "--prefix=#{prefix}",
                          "--libdir=#{lib}/#{target}",
                          "--infodir=#{info}/#{target}",
                          "--with-system-zlib",
                          "--with-zstd",
                          "--disable-nls"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test-s.s").write <<~ASM
      .section .data
      .section .text
      .globl _start
      _start:
          movl $1, %eax
          movl $4, %ebx
          int $0x80
    ASM

    system bin/"i686-elf-as", "--32", "-o", "test-s.o", "test-s.s"
    assert_match "file format elf32-i386",
      shell_output("#{bin}/i686-elf-objdump -a test-s.o")
  end
end
