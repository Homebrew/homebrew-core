class ArmNoneEabiBinutils < Formula
  desc "GNU Binutils for arm-none-eabi cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.46.0.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.46.0.tar.bz2"
  sha256 "0f3152632a2a9ce066f20963e9bb40af7cf85b9b6c409ed892fd0676e84ecd12"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_tahoe:   "d1baef214ada2afce70175e99a32789a5fad6b7829c35f2ee7e122016c6f8b7c"
    sha256 arm64_sequoia: "cd7ff17977a024abe392efd07efaa2179b8536db74f467268df43b4402caf624"
    sha256 arm64_sonoma:  "f9d32841a1662755745d2d0a1cf5fc7ad58620e94eac8a2c70f1cd053f9b8e90"
    sha256 sonoma:        "d964cf93c517619de9897beccb51701aa960ccdf20045f7b7d41a331c8ace5c5"
    sha256 arm64_linux:   "2797e667da0789c94ddb173e1f1addb72bde1cf6c5f362a49874bf4b1f8d9d06"
    sha256 x86_64_linux:  "a5799d18def773ecb8f7987f0646d11d90d8c610649af7ac9f14a3e7f191f04e"
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
