class ArmNoneEabiBinutils < Formula
  desc "GNU Binutils for arm-none-eabi cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.41.tar.bz2"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.41.tar.bz2"
  sha256 "a4c4bec052f7b8370024e60389e194377f3f48b56618418ea51067f67aaab30b"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_ventura:  "19b97c0c5ba06d42d8dab51ca0af3e9c94f61a05270bff7338c65bb0ef247c57"
    sha256 arm64_monterey: "1f9dd28a479392d5e667f9711420f2a99a9de55fd64ec4df34cb9cbb89a23409"
    sha256 arm64_big_sur:  "7805614e7fdb88b69cfe06a7ebc4438c24e5ed801f3e484093a1e4e2a5f28447"
    sha256 ventura:        "22cff9b8e59fa3b843f000588060fcb50870711578aa1258931a223f4ebacf0b"
    sha256 monterey:       "5579dbbc1307fe765889e12652392eacfc0099fc90b0c7ec5e3806564bcd3cf5"
    sha256 big_sur:        "d092d61e81ca06993226fbe1cd59023263440a5ae6e7e8aa01f1446118be19c7"
    sha256 x86_64_linux:   "fb6707492d6eceb4aa31bdfac836971bdb57667968a3361c1e71c583e3361e9d"
  end

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    target = "arm-none-eabi"
    system "./configure", "--target=#{target}",
           "--prefix=#{prefix}",
           "--libdir=#{lib}/#{target}",
           "--infodir=#{info}/#{target}",
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
