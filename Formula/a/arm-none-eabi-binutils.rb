class ArmNoneEabiBinutils < Formula
  desc "GNU Binutils for arm-none-eabi cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.41.tar.bz2"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.41.tar.bz2"
  sha256 "a4c4bec052f7b8370024e60389e194377f3f48b56618418ea51067f67aaab30b"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_sonoma:   "a5ca2ee90a23fcc0e5ca0be2556a7dd24f18708db36fe1bd88c4b6a03e12964d"
    sha256 arm64_ventura:  "08a81e4145ffb484c64eba406e46cce4ef7a9af239950dc9d7af8e620743ed34"
    sha256 arm64_monterey: "eb81cd47a50665b14188ede745dac4b1473fc0d3dac3465e5f679ae3704b6f8a"
    sha256 sonoma:         "88e43bd750b5378c2fb29c5c4d0e18897617d6a3a33932f0a0f9c6975718eb8d"
    sha256 ventura:        "d2582d466f0d3a87dbc07b98d4ac25c1f0bdf84330c92dca0069d636a1ecdd76"
    sha256 monterey:       "d2e7f96d10ac013e7eade322be3240d816786596ea820cc58c08679b0836ad5a"
    sha256 x86_64_linux:   "1b26208378337642d8a87e763d4861371e4d537cd4f5f0d12822b0a162e96d23"
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
