class Nasm < Formula
  desc "Netwide Assembler (NASM) is an 80x86 assembler"
  homepage "https://www.nasm.us/"
  url "https://www.nasm.us/pub/nasm/releasebuilds/2.14.01/nasm-2.14.01.tar.xz"
  sha256 "c28dfae587d59409a91271971268020ade1809a191fefdffa81e6800609ac014"

  bottle do
    cellar :any_skip_relocation
    sha256 "616fdab3c5f856c051bc2cd50556082c1a575533f76913e9623dffa0ab4887bb" => :mojave
    sha256 "316dc210d7bb769c034a9373c4dd084a6accca8ef42e3139d6df5abf5cb57d0c" => :high_sierra
    sha256 "1e17ae47d141be6b57cdbb6f9638dba8f0ef30f6499b27a31d82c50bc1577983" => :sierra
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
