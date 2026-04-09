class Nasm < Formula
  desc "Netwide Assembler (NASM) is an 80x86 assembler"
  homepage "https://www.nasm.us/"
  url "https://www.nasm.us/pub/nasm/releasebuilds/3.01/nasm-3.01.tar.xz"
  sha256 "b7324cbe86e767b65f26f467ed8b12ad80e124e3ccb89076855c98e43a9eddd4"
  license "BSD-2-Clause"

  livecheck do
    url "https://www.nasm.us/pub/nasm/releasebuilds/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5074568719d225be8b29c51a67afb5a4feec97f58736cd18cd1534eefa11df5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88f144c41ed757649726c4ed2247cdbc75621bdf57c2b27f17fc784c6e28d3f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eca617b897d2e594511ca59690799341e9600e2e511ee95e057a36b28dde0edd"
    sha256 cellar: :any_skip_relocation, sonoma:        "56b4849156efbe9ef0a4d615a36a4e58f5d9cc098a4c56e161489490189e6f56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2653ec1582df302177334313b005f06c6ae4df44194f72742406eaa47e5b6065"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2bb9cd0b3ae85202e0584e4a088c9bcec70cccbb4f619465fae0210f95151dc"
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
