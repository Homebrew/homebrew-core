class Lwtools < Formula
  desc "Cross-development tools for Motorola 6809 and Hitachi 6309"
  homepage "http://www.lwtools.ca/"
  url "http://www.lwtools.ca/releases/lwtools/lwtools-4.24.tar.gz"
  sha256 "b38a2baad15c017bb7cd8144218e7af61abccf21fd25f7b1a35e6529acd7b3dd"
  license "GPL-3.0-only"

  livecheck do
    url "http://www.lwtools.ca/releases/lwtools/"
    regex(/href=.*?lwtools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f904db8779abd74708ebadd543361ae5f9ffee9a764cfe8ce3ff0e5db32d1f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf4cd6f23617d013f4089741a4ff693a2d0c22b92b0d978a3a7c2b715382a0ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "433acd7c0e10e9a77f57dc2a96db7c0b90e0714c1537206d98dadf36bbcf7869"
    sha256 cellar: :any_skip_relocation, sonoma:        "13ff219d341591d4612e649fff1f87e4978d91ca440f096d7189a9382abacfc2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8140c9ed5b53b94b1abe2a57951fc16e57d01a962a554c9b3e69fbf4c4cc882"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "209fcd523569b4579aca0fffe15766ec01190f2e7e0426af08107ccf7971e166"
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # lwasm
    (testpath/"foo.asm").write "  SECTION foo\n  stb $1234,x\n"
    system bin/"lwasm", "--obj", "--output=foo.obj", "foo.asm"

    # lwlink
    system bin/"lwlink", "--format=raw", "--output=foo.bin", "foo.obj"
    code = File.open("foo.bin", "rb") { |f| f.read.unpack("C*") }
    assert_equal [0xe7, 0x89, 0x12, 0x34], code

    # lwobjdump
    assert_match(/^SECTION foo/, shell_output("#{bin}/lwobjdump foo.obj"))

    # lwar
    system bin/"lwar", "--create", "foo.lwa", "foo.obj"
    assert_match(/^foo.obj/, shell_output("#{bin}/lwar --list foo.lwa"))
  end
end
