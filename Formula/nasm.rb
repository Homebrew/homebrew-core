class Nasm < Formula
  desc "Netwide Assembler (NASM) is an 80x86 assembler"
  homepage "http://www.nasm.us/"
  url "http://www.nasm.us/pub/nasm/releasebuilds/2.13.03/nasm-2.13.03.tar.xz"
  sha256 "812ecfb0dcbc5bd409aaa8f61c7de94c5b8752a7b00c632883d15b2ed6452573"

  bottle do
    cellar :any_skip_relocation
    sha256 "c85b863a69d578d3939543ba336fa09361ba69ef41352702dee297044299ee2e" => :high_sierra
    sha256 "7707dec14dd94ac8a0890b98d2f98364cf2e87463456a470925cb1173f67906c" => :sierra
    sha256 "52af51190b40798a1e2a8413a3130a4392f089c8973d18afcca0bd365d894071" => :el_capitan
  end

  head do
    url "http://repo.or.cz/nasm.git"
    depends_on "autoconf" => :build
    depends_on "asciidoc" => :build
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
    (testpath/"foo.s").write <<-EOS
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
