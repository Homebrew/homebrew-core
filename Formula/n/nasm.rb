class Nasm < Formula
  desc "Netwide Assembler (NASM) is an 80x86 assembler"
  homepage "https://www.nasm.us/"
  url "https://www.nasm.us/pub/nasm/releasebuilds/3.00/nasm-3.00.tar.xz"
  sha256 "85c51ffc7d2804274b16d1821e1dd84c1b9164120b0b1221b95bd57a89d278f2"
  license "BSD-2-Clause"

  livecheck do
    url "https://www.nasm.us/pub/nasm/releasebuilds/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "068e7ce07b423159f2ed316cada16a18a6c0d3fa404b79ed7b6bcec4d18c3535"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6126cc68af10ddee8770180ed769611b14bdac77f9acc1c85408011ae98fdb55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93b503ad90057283109124c968b2ff861b93152cbe8a28406c2a7b0d564d74d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f9ea5599a562f49789fd287ae73312bedab53ec52e0da9a26ca13321fbeb3e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16df305a4d33ee046fe0657ad83f18218ad44c602498cfecbd784918394471af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d474eca8ca7672936d93a1dc01a8800dd439aaac04de37ed233a69f6b18d9c31"
  end

  head do
    url "https://github.com/netwide-assembler/nasm.git", branch: "master"
    depends_on "asciidoc" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "xmlto" => :build
  end

  def install
    # Work around upstream bug
    # https://github.com/netwide-assembler/nasm/commit/dc247c9f9913e336200ecf8bb72152fdabdb3585#r167178007
    inreplace "include/bytesex.h", "l32toh(", "le32toh("

    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "manpages" if build.head?
    system "make", "install"
  end

  test do
    (testpath/"foo.s").write <<~ASM
      mov eax, 0
      mov ebx, 0
      int 0x80
    ASM

    system bin/"nasm", "foo.s"
    code = File.open("foo", "rb") { |f| f.read.unpack("C*") }
    expected = [0x66, 0xb8, 0x00, 0x00, 0x00, 0x00, 0x66, 0xbb,
                0x00, 0x00, 0x00, 0x00, 0xcd, 0x80]
    assert_equal expected, code
  end
end
