class Nasm < Formula
  desc "Netwide Assembler (NASM) is an 80x86 assembler"
  homepage "http://www.nasm.us/"
  url "http://www.nasm.us/pub/nasm/releasebuilds/2.12.02/nasm-2.12.02.tar.xz"
  sha256 "4c866b60c0b1c4ebc715205d007b4640ff4e36af637c9a7deb87b2900e544321"

  bottle do
    cellar :any_skip_relocation
    sha256 "d8763b4360c196f58d978d35b2aa59873c00ebf7b4859092a6b5f0c57f80bba3" => :el_capitan
    sha256 "b5e0065fbda4bc95c00bb43e157698fd853cba2eaddfa77b15d2c5349d38d416" => :yosemite
    sha256 "6e0a8849f85a2c2f7729c270bf42ac4525188eda1a524287a061d18240c13f52" => :mavericks
  end

  head do
    url "git://repo.or.cz/nasm.git"
    depends_on "autoconf" => :build
    depends_on "asciidoc" => :build
    depends_on "xmlto" => :build
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "manpages" if build.head?
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
