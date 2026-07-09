class ArmNoneEabiBinutils < Formula
  desc "GNU Binutils for arm-none-eabi cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.46.1.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.46.1.tar.bz2"
  sha256 "324ed40ada2633a28eaa5d104ca5db165fd3cc3162cc1d48a7b7fa9c932da439"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_tahoe:   "ef7451e2e74749bf2b1c647c2846627315c297753de9084f3f7e0e8036b6cf13"
    sha256 arm64_sequoia: "50c39c268a832d18bf2372a7bd283d9c97285b7c73d88f0adcada328f4ab6d90"
    sha256 arm64_sonoma:  "33d3b5794a2a00b0d0db12520d217d5987c07f7bf3a2fbaffdeabca2b68cad14"
    sha256 sonoma:        "ab15e6754183a1a5bcb4743cb32256640958635dc27339524f78fde15bdb9d4d"
    sha256 arm64_linux:   "3238fe5f016a8e33f5655fe894d83b1cd9e15c558abbb552779e547c5cd87f30"
    sha256 x86_64_linux:  "a54edc7b78f3e65e0518a83a810b7c3dc33b046531d4adc81ad8d83d450a9550"
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
