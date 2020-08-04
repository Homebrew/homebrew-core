class Nasm < Formula
  desc "Netwide Assembler (NASM) is an 80x86 assembler"
  homepage "https://www.nasm.us/"
  url "https://www.nasm.us/pub/nasm/releasebuilds/2.15.03/nasm-2.15.03.tar.xz"
  sha256 "c0c39a305f08ccf0c5c6edba4294dd2851b3925b6d9642dd1efd62f72829822f"
  license "BSD-2-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "cbfd79dae0adf49b161549e937be1a32ed8b2672995afcd08abb4683dc4114d5" => :catalina
    sha256 "3056dc42c3cbdf9364cce58f6f1f374b6c2c8d4e0fd79ee7a8bd7a62723f040a" => :mojave
    sha256 "f4cf9a2a41ee8270a952dc15e70ee198dec7bbf10c151053c6ef4556b32b2b7e" => :high_sierra
  end

  head do
    url "https://github.com/netwide-assembler/nasm.git"
    depends_on "asciidoc" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "xmlto" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "manpages" if build.head?
    system "make", "rdf"
    system "make", "install", "install_rdf"
  end

  test do
    (testpath/"foo.s").write <<~EOS
      mov eax, 0
      mov ebx, 0
      int 0x80
    EOS

    system "#{bin}/nasm", "foo.s"
    code = File.open("foo", "rb") { |f| f.read.unpack("C*") }
    expected = [0x66, 0xb8, 0x00, 0x00, 0x00, 0x00, 0x66, 0xbb,
                0x00, 0x00, 0x00, 0x00, 0xcd, 0x80]
    assert_equal expected, code
  end
end
