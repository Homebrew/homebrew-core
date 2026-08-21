class Lwtools < Formula
  desc "Cross-development tools for Motorola 6809 and Hitachi 6309"
  homepage "https://www.lwtools.ca/"
  url "https://www.lwtools.ca/releases/lwtools/lwtools-4.25.tar.gz"
  sha256 "a61fb716ed054951f8cd8f1cbad58363eb2115f5ce18af97d5f188e01fb5fcda"
  license "GPL-3.0-only"

  livecheck do
    url "https://www.lwtools.ca/releases/lwtools/"
    regex(/href=.*?lwtools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77612ade9fcd6272b8f4f5f27c9ed4ab80616130067e51f9b823d42c8219dc3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffe93d375d527663e0ecf2e291752893016d59dcb1809fc44038370233ce08af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7cc667f7f9f67f5eb787badbe49bbfaf7928ee788ce9d02c73860a63e05a88cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ad4a15723bf7a7a6652c028036befaea96881c5e4625064c7640ca615a7021c"
    sha256 cellar: :any,                 arm64_linux:   "9ea661cad88ac0099fcc28c1ecd7a2947190b05962403aa12755350d101df574"
    sha256 cellar: :any,                 x86_64_linux:  "aeb524b30f7e8867525e95cc255fbac0b62902a692d1b6b18488195733978689"
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
