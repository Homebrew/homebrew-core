class ArmNoneEabiBinutils < Formula
  desc "GNU Binutils for arm-none-eabi cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.42.tar.bz2"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.42.tar.bz2"
  sha256 "aa54850ebda5064c72cd4ec2d9b056c294252991486350d9a97ab2a6dfdfaf12"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_sonoma:   "b82ed5a5507bbe523bc55a4d473aeeaca74570ee1c94cc7dd8188d8020d7b665"
    sha256 arm64_ventura:  "b33b0cd2e7c42a2bdfcf919350ed995ffc003da961abb87bbb3bf36559e56bbe"
    sha256 arm64_monterey: "79f5e3fc8ffce47b285e216fedc19d66728dc51c3434b1fe2de882d2fe327880"
    sha256 sonoma:         "0885e00faffffd3dbb00d168a5c5aa539c88c3f1c1c8d873276a9635f109acc8"
    sha256 ventura:        "757738e5aff243abdb5043fd7ed7ebcdee4eeafc19348fa3ac6539edcf522b5f"
    sha256 monterey:       "0da93a8ec33abb7f200fb9f6361b12910648010e1fb340a4f4d81fedf9e1e2c5"
    sha256 x86_64_linux:   "6f87c18fbd3c298bddb27d7031e1e1292fc574bae017424d01dfd095ff89cae9"
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
    system "#{bin}/arm-none-eabi-as", "-o", "test-s.o", "test-s.s"
    assert_match "file format elf32-littlearm",
                 shell_output("#{bin}/arm-none-eabi-objdump -a test-s.o")
    assert_match "f()", shell_output("#{bin}/arm-none-eabi-c++filt _Z1fv")
  end
end
