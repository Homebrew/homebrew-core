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
    sha256 arm64_sequoia:  "3ede55fd67ae38d15ea1a383a32c230ddb0a2d6057bfd044b22243220ec48773"
    sha256 arm64_sonoma:   "458b71485352dd068e53201d3dfd0ae417f79e384be6c816c698ed91a5a21807"
    sha256 arm64_ventura:  "9461459c5f9f830ffbd029b10ae10e89b54e031a654364843d2cc481dc408168"
    sha256 arm64_monterey: "1104d62a87e30a3700af18eecb281a22211cf48d90e270430c63c7d69facc0f1"
    sha256 sonoma:         "503af491e4b77482a66f288f54c29a9d00c2ebeab5567cd68199c635e51c96f7"
    sha256 ventura:        "452522df713af1ba29de9deff36d6fab797968184ce125db047c65ab55a76e2d"
    sha256 monterey:       "f91d4b2fbbf3a0f2320f98c4ab78449276331d68956383a2e11c266d06ac9955"
    sha256 x86_64_linux:   "b76702db7f7daed88627a97c16ffc1d028ad34f3a6fcf2fc8e8c1ee6d16d562e"
  end

  depends_on "pkg-config" => :build
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
           "--disable-nls"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test-s.s").write <<~EOS
      .section .text
      .globl _start
      _start:
          mov r1, #0
          mov r2, #1
          svc #0x80
    EOS

    system bin/"arm-none-eabi-as", "-o", "test-s.o", "test-s.s"
    assert_match "file format elf32-littlearm",
                 shell_output("#{bin}/arm-none-eabi-objdump -a test-s.o")
    assert_match "f()", shell_output("#{bin}/arm-none-eabi-c++filt _Z1fv")
  end
end
