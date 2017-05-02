class Nasm < Formula
  desc "Netwide Assembler (NASM) is an 80x86 assembler"
  homepage "http://www.nasm.us/"
  url "http://www.nasm.us/pub/nasm/releasebuilds/2.13.01/nasm-2.13.01.tar.xz"
  sha256 "aa0213008f0433ecbe07bb628506a5c4be8079be20fc3532a5031fd639db9a5e"

  bottle do
    cellar :any_skip_relocation
    sha256 "860a5771f9880a4f14ece39fed4f1819ffd0af24b3ae5293f24cdc940f2d7a09" => :sierra
    sha256 "fdebb76534438bda64a7e6d0e2d72d048db000c8b77ada699b0a1e9a5c306e56" => :el_capitan
    sha256 "9bc7dd9f82c75e3f4557d73dcee0191a32f0f7b78450b2ec486cc5b41f699b0a" => :yosemite
  end

  head do
    url "git://repo.or.cz/nasm.git"
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
