class Nasm < Formula
  desc "Netwide Assembler (NASM) is an 80x86 assembler"
  homepage "https://www.nasm.us/"
  url "https://www.nasm.us/pub/nasm/releasebuilds/2.15.02/nasm-2.15.02.tar.xz"
  sha256 "f4fd1329b1713e1ccd34b2fc121c4bcd278c9f91cc4cb205ae8fcd2e4728dd14"

  bottle do
    cellar :any_skip_relocation
    sha256 "78a5c441bb57c5cb0a70a54183fa5685b1f31800f0fa13f97d36b01029f0f243" => :catalina
    sha256 "f9cfc8ad4a4a6e671da2ab8fd12ea19faac331bc427b54b16f5ece9e29a50843" => :mojave
    sha256 "269f9428ff92c073e4d9d7313d76bbfb11b4d971819d6c807cc09b75c2e2748e" => :high_sierra
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
