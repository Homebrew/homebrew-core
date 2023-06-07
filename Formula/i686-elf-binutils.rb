class I686ElfBinutils < Formula
  desc "GNU Binutils for i686-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.40.tar.bz2"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.40.tar.bz2"
  sha256 "f8298eb153a4b37d112e945aa5cb2850040bcf26a3ea65b5a715c83afe05e48a"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_ventura:  "fab6e87ee627c0f7c69c474c91100423a7ac02ab874f181d2c1817506476990d"
    sha256 arm64_monterey: "73236de42e1bf543d835f981f3089715cdb1e3d85a5c0bc9dc0b31a675e20267"
    sha256 arm64_big_sur:  "e35449a94557c283ec4f309e8e7c94e21ce8f0c249d59d1706e703759d45007d"
    sha256 ventura:        "a84b87b1ba0e93db903a4fd18fc7982c4e99fe6d6c1292a93fc0981a6250a3fe"
    sha256 monterey:       "ac18dbac512eef87289290143a1987893d2ef178d262d12cf0b6d495374d28d6"
    sha256 big_sur:        "d48940229bd80020caaf65ba18959095819dba896d60bb8af4014ac85933270f"
    sha256 x86_64_linux:   "f184ca36b2f1321321fdb73f1521a23d56f292108a6133941e518fbd7f3b3d65"
  end

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    target = "i686-elf"
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
      .section .data
      .section .text
      .globl _start
      _start:
          movl $1, %eax
          movl $4, %ebx
          int $0x80
    EOS
    system "#{bin}/i686-elf-as", "--32", "-o", "test-s.o", "test-s.s"
    assert_match "file format elf32-i386",
      shell_output("#{bin}/i686-elf-objdump -a test-s.o")
  end
end
