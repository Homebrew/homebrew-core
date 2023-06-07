class Aarch64ElfBinutils < Formula
  desc "GNU Binutils for aarch64-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.40.tar.bz2"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.40.tar.bz2"
  sha256 "f8298eb153a4b37d112e945aa5cb2850040bcf26a3ea65b5a715c83afe05e48a"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_ventura:  "5c49fbe8956d46572b14d30aac96dea362d9fe027afed084f152f43a4a278d49"
    sha256 arm64_monterey: "3b064370a49cdc8e23ce9f46d9f806de6e974ceb6ea88cc487fa23348189dbd6"
    sha256 arm64_big_sur:  "e31ec863273eb6a9d49ccc00c94e3f9b2ce97bfdf5ac9ff3bce88b1655fa20e4"
    sha256 ventura:        "b6a33fe5905aa39cfb378459ae42e995e83749daff229d293c88811838527e96"
    sha256 monterey:       "d14fe23ba928f82a86d1f42b1dd980986e742c191f7b83d09d7c04f91fd7d565"
    sha256 big_sur:        "c14e10801e0a5be2f738b4073eee6dd2c7fff7448fde1556090f42295cae4bd0"
    sha256 x86_64_linux:   "f5dddac8b6b0b641298ac06706a0b7db79f93c42e987a0a9508955ad8e8d9f29"
  end

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    target = "aarch64-elf"
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
          mov x0, #0
          mov x16, #1
          svc #0x80
    EOS
    system "#{bin}/aarch64-elf-as", "-o", "test-s.o", "test-s.s"
    assert_match "file format elf64-littleaarch64",
                 shell_output("#{bin}/aarch64-elf-objdump -a test-s.o")
    assert_match "f()", shell_output("#{bin}/aarch64-elf-c++filt _Z1fv")
  end
end
