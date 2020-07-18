class Nasm < Formula
  desc "Netwide Assembler (NASM) is an 80x86 assembler"
  homepage "https://www.nasm.us/"
  url "https://www.nasm.us/pub/nasm/releasebuilds/2.15.03/nasm-2.15.03.tar.xz"
  sha256 "c0c39a305f08ccf0c5c6edba4294dd2851b3925b6d9642dd1efd62f72829822f"

  bottle do
    cellar :any_skip_relocation
    sha256 "8bd0bdbfb3471d37857357458dc599650465b53d1661459900f61ef60effe4a1" => :catalina
    sha256 "833f4b88e5d32727234e7934d77eebafa661b868bc19dc320fa032ab72e8419a" => :mojave
    sha256 "457a1648b0b8447bd693068e10c366dcda1a71dc4ce0f27838520b32db653d01" => :high_sierra
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
