class ArmNoneEabiBinutils < Formula
  desc "GNU Binutils for arm-none-eabi cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.45.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.45.tar.bz2"
  sha256 "1393f90db70c2ebd785fb434d6127f8888c559d5eeb9c006c354b203bab3473e"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_tahoe:   "5f7ce2be887c3bcb53d7e15e70d7ea560fc87ac3df99da6936233335ffd15967"
    sha256 arm64_sequoia: "9d2d6391ad41a79397d221cc7def963c36afbae486a6063f33400244ed640beb"
    sha256 arm64_sonoma:  "cd29ee3d38b8e7f479ffbd0c9467d5c752f26c80eb9ac5bb0ff96625d58d92ce"
    sha256 arm64_ventura: "42e5869d2ab0312188377d65b066f0bf612773445c51f9801dc2a67642cd4a37"
    sha256 sonoma:        "827b68df4de6ee8faa94066073e9c4b68dc24f4bf05a20294b9847001becc890"
    sha256 ventura:       "74db40f7b62e88c11db9270d1f2e4f594b8ba69117a634f54a5b1414837260d0"
    sha256 arm64_linux:   "66359d623c04dc1ab75a3c59cc557add208046e847d33f196218cac9ddadebd7"
    sha256 x86_64_linux:  "ad176f02f9fe696910855d5f9a70f2fefc54095f8a22fcc0054dc8e76b1d42ec"
  end

  depends_on "pkgconf" => :build
  depends_on "zstd"

  uses_from_macos "zlib"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    target = "arm-none-eabi"
    system "./configure", "--target=#{target}",
                          "--prefix=#{prefix}",
                          "--libdir=#{lib}/#{target}",
                          "--infodir=#{info}/#{target}",
                          "--with-system-zlib",
                          "--with-zstd",
                          "--enable-multilib",
                          "--disable-nls"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test-s.s").write <<~ASM
      .section .text
      .globl _start
      _start:
          mov r1, #0
          mov r2, #1
          svc #0x80
    ASM

    system bin/"arm-none-eabi-as", "-o", "test-s.o", "test-s.s"
    assert_match "file format elf32-littlearm",
                 shell_output("#{bin}/arm-none-eabi-objdump -a test-s.o")
    assert_match "f()", shell_output("#{bin}/arm-none-eabi-c++filt _Z1fv")
  end
end
