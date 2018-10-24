class Nasm < Formula
  desc "Netwide Assembler (NASM) is an 80x86 assembler"
  homepage "https://www.nasm.us/"
  url "https://www.nasm.us/pub/nasm/releasebuilds/2.13.03/nasm-2.13.03.tar.xz"
  mirror "https://dl.bintray.com/homebrew/mirror/nasm-2.13.03.tar.xz"
  sha256 "812ecfb0dcbc5bd409aaa8f61c7de94c5b8752a7b00c632883d15b2ed6452573"

  bottle do
    cellar :any_skip_relocation
    sha256 "2be4a0cadd8182d4a031d51087a0bf4f1dc7b0ebcc0090aedcb7366eaf2af30d" => :mojave
    sha256 "2fa5bb8d830cb03115cc2f12a03dd15bf49674324604760019f3170b5cc089fd" => :high_sierra
    sha256 "0a7e744e56384aae2dd1a9a80c6ae8037fa3c4a0b0481a7c403dbf8db2c1cf19" => :sierra
    sha256 "071188eaf2b8b37f7de944306eddaa632ef7892ef0d9df58fb1aa5fac3bf8b7a" => :el_capitan
  end

  head do
    url "https://repo.or.cz/nasm.git"
    depends_on "asciidoc" => :build
    depends_on "autoconf" => :build
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
