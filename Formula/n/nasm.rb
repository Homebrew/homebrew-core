class Nasm < Formula
  desc "Netwide Assembler (NASM) is an 80x86 assembler"
  homepage "https://www.nasm.us/"
  url "https://www.nasm.us/pub/nasm/releasebuilds/3.02/nasm-3.02.tar.xz"
  sha256 "87336eba53b4acfe917424ab5d500d2b0054d9f5148d35c2273ccf2cfb712f0d"
  license "BSD-2-Clause"

  livecheck do
    url "https://www.nasm.us/pub/nasm/releasebuilds/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23bc78cddac86f63a7b19cb0766614a868e0d356dc2091d0f789027c4809a75a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be638eb35844e4292072b1fe70de30211aa9f189b81eb2801a78be0b253f3fc9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9cddb141c3a766a8f3414ba26e0f126f407dccef322cc264144018fcdec965c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5d1b6674c2e03de920175e8c0a9ad219ab710640a95e9f420bba6868fec3449"
    sha256 cellar: :any,                 arm64_linux:   "18f8816daa6fb03f4d9d94704af5a11926852b7857c0980b23f7927ffdc0ac37"
    sha256 cellar: :any,                 x86_64_linux:  "0627373a9962904143c0c4903187e22ddd5442c42856ae66cb6c5bb4857cfcab"
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
