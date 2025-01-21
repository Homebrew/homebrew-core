class ArmNoneEabiBinutils < Formula
  desc "GNU Binutils for arm-none-eabi cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.43.1.tar.bz2"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.43.1.tar.bz2"
  sha256 "becaac5d295e037587b63a42fad57fe3d9d7b83f478eb24b67f9eec5d0f1872f"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "79e64e093d75dac53fc108ddb4a81c6aa9ad3e7ff3e38ddb170b749259d4a393"
    sha256 arm64_sonoma:  "2928334e9880b74d00dfb640d909bfcbce23b3afeb0b25898cc6d7ff8a236dbf"
    sha256 arm64_ventura: "438273581d790ad5519989cbdabbfa655abffa60e33ceeb9445a91a31d2c58bb"
    sha256 sonoma:        "2c2d9de7c9a63d13257b9fb85cd959578321cd9dc38d7073095827ff8f906907"
    sha256 ventura:       "5a55da2c132a5906d455fe7d054a1f76aadc82b71cc701a90e6677907bdd2cbc"
    sha256 x86_64_linux:  "ee375c801fe9d934f983b43c293390c9d4318cdb02403560799a845746ce0597"
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
