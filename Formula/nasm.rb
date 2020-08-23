class Nasm < Formula
  desc "Netwide Assembler (NASM) is an 80x86 assembler"
  homepage "https://www.nasm.us/"
  url "https://www.nasm.us/pub/nasm/releasebuilds/2.15.04/nasm-2.15.04.tar.xz"
  sha256 "b0891d23aa083546e7845dfaa0a9109a03f1f57ad0740e7acd07f80df57876d8"
  license "BSD-2-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "315f2a7e515fc7a3992ec97f25b0aa4dbb4d25fdf92799fa531e802bc1295794" => :catalina
    sha256 "ad4453ef53d54d6e383b1428b435cd6b6fb6eb3e61086ae9b41e25f944342da2" => :mojave
    sha256 "f6bf9215f161c14d4b7874e23b4e1093ca99b6fac5bc88172386fd998fb6f5ce" => :high_sierra
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
