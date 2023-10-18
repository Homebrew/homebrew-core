class Nasm < Formula
  desc "Netwide Assembler (NASM) is an 80x86 assembler"
  homepage "https://www.nasm.us/"
  url "https://www.nasm.us/pub/nasm/releasebuilds/2.16.01/nasm-2.16.01.tar.xz"
  sha256 "c77745f4802375efeee2ec5c0ad6b7f037ea9c87c92b149a9637ff099f162558"
  license "BSD-2-Clause"

  livecheck do
    url "https://www.nasm.us/pub/nasm/releasebuilds/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "be92e6b4bf9c6e3e849a22bc23926b84b6bb14644f504196fb5850c0c26d2b0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02df045dde4735c52ea36c9609c7b2ef99a3b6c5ab093ec05fd291b38c4fdc71"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d98addbc6b5604ca6bf1a916e1fe76e1d488581fe5355c578f3c961481abe38"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c2def9652f23b51184519af9711aabc6bdca5de580cc6a9a4651acf7f87bdff"
    sha256 cellar: :any_skip_relocation, sonoma:         "4f94fa0a9646be0477dd7764d51fb67e766fba598b4d6c7d9d23c29422105392"
    sha256 cellar: :any_skip_relocation, ventura:        "fb151fd253a9835758f054c59b92d7fc9f9ecb3462177d39efe30270b8f12554"
    sha256 cellar: :any_skip_relocation, monterey:       "2c0b7ce0b682907a0d99058cb4d2d383c63a6aa5ac08c7303de971aa3d5545ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "cad590054e62ed818fc429fc721fc7bb0e56d03a277106344f0a4615a7cd8bfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "228c7c21807b417826e1c8c833e40dfd3db93ec34897f6a91b8cdeb208700f81"
  end

  head do
    url "https://github.com/netwide-assembler/nasm.git", branch: "master"
    depends_on "asciidoc" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "xmlto" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "manpages" if build.head?
    system "make", "install"
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
