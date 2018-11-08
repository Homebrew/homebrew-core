class Nasm < Formula
  desc "Netwide Assembler (NASM) is an 80x86 assembler"
  homepage "https://www.nasm.us/"
  url "https://www.nasm.us/pub/nasm/releasebuilds/2.14/nasm-2.14.tar.xz"
  sha256 "97c615dbf02ef80e4e2b6c385f7e28368d51efc214daa98e600ca4572500eec0"

  bottle do
    cellar :any_skip_relocation
    sha256 "89165be514c28651d474a7f9455e9ab916542cec50ecce3cfcef114277c60707" => :mojave
    sha256 "af12fee78edfa24fad74389a17814296826eab230e84ce519ee61782be3a44e6" => :high_sierra
    sha256 "dba53c9cadfd7cc537260f3a9c8becb322218787468a75da280fa06c6428f454" => :sierra
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
