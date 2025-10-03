class I686ElfBinutils < Formula
  desc "GNU Binutils for i686-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.45.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.45.tar.bz2"
  sha256 "1393f90db70c2ebd785fb434d6127f8888c559d5eeb9c006c354b203bab3473e"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_tahoe:   "d870e8ffcb6255ca1334f70a67e964aeb87fc4e9c8bdfd521a43b702d76b423a"
    sha256 arm64_sequoia: "8684b6b23cf9d5d3f0ad0fa652a649c1e65ad15e78082066f2a8e9c9968ed50d"
    sha256 arm64_sonoma:  "6adca43d6b69591fee0f163524a01fe3ca81b3dc2f947e07f7785cb8fea448ba"
    sha256 arm64_ventura: "2a0e78e859bcc772f2dfd17d583994ee200181983e22121416764aeab6c1dbad"
    sha256 sonoma:        "98f0a4a7768da2533d10226168b26e75546c0b643454894071d844879178e018"
    sha256 ventura:       "0f10371161ab0f953fd320f6f91fe7367c5b0a05130310c21fb34e7976fdd1f1"
    sha256 arm64_linux:   "55fc5cdb820fb1b6980be16378426fdbd47a8ce196899b65bc595cc36694d8fe"
    sha256 x86_64_linux:  "4567da79445e4c0a309fda411578bc286e218d3cee3d9453e966d75f38a0f97d"
  end

  depends_on "pkgconf" => :build
  depends_on "zstd"

  uses_from_macos "zlib"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
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
