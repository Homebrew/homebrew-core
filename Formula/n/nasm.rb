class Nasm < Formula
  desc "Netwide Assembler (NASM) is an 80x86 assembler"
  homepage "https://www.nasm.us/"
  url "https://www.nasm.us/pub/nasm/releasebuilds/2.16.02/nasm-2.16.02.tar.xz"
  sha256 "1e1b942ea88f22edae89659e15be26fa027eae0747f51413540f52d4eac4790d"
  license "BSD-2-Clause"

  livecheck do
    url "https://www.nasm.us/pub/nasm/releasebuilds/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "80447335b3dde2c4da228a5dda1cbbf53f7baa3d7904255c13d2896ad85937de"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8e0252c54db6230964730882e72c13d968b01995908798834e38a64324240ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82c5c64586350e02bad4d8d5508858eb49428bb81ac9294a3eef6c87cfdccef9"
    sha256 cellar: :any_skip_relocation, sonoma:         "e83707a68e7e618cdfed0341970ef3414be2aff345c0ff1324daceba2456e791"
    sha256 cellar: :any_skip_relocation, ventura:        "5023a1769bfaf3a73c86aea867e6ef1cdb2bef9fd5cc164dc6cb65b1d977fb8d"
    sha256 cellar: :any_skip_relocation, monterey:       "ddf8a09b1a2f2021e142cdcdf0e8964c87b436ed8b0a308995c9bb83ad136192"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d291cabdb23d18109e5f338ba26f1e19d609367a0e88aa62ba178a456829829"
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
