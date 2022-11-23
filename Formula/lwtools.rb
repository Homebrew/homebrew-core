class Lwtools < Formula
  desc "Cross-development tools for Motorola 6809 and Hitachi 6309"
  homepage "http://www.lwtools.ca/"
  url "http://www.lwtools.ca/releases/lwtools/lwtools-4.20.tar.gz"
  sha256 "58ef6d09c5b69885c06f8bc73be3ee739e9ce3b7ceb3422fabdd892fd72917d4"
  license "GPL-3.0-only"

  livecheck do
    url "http://www.lwtools.ca/releases/lwtools/"
    regex(/href=.*?lwtools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f16017de3e51342744d34b0ed40d8df51bc7b900577db1657b7fa0a2c3ace16"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17c44cb127a40b306eb838bfff0dd8ebaa052ff712e63f20d1677f0b69e26e3c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11825578987a2aaaa08ddf2ebf67921c5e46c7ff712cded183e71d95b465d267"
    sha256 cellar: :any_skip_relocation, ventura:        "f5109f76328da4ca694bb4cd591a16ccaf5dd47921fee9e952cd9375be25784f"
    sha256 cellar: :any_skip_relocation, monterey:       "7037098728211b7aac84cfcbadcf7260b62fdb417b04b80fa755597b571c34e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "e5ba969783c40c2a6772c0d4afd7e3df58fdacdb0e83fb6865c9d74d7f737c24"
    sha256 cellar: :any_skip_relocation, catalina:       "676551e684a6b379be7605d61cd87274a718b9955af77618ce5eacd6b75eb03c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4178ef6d2a56b0f6bcd0b4dca4d296df4301dc12883328105d526f1fc3014ece"
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # lwasm
    (testpath/"foo.asm").write "  SECTION foo\n  stb $1234,x\n"
    system "#{bin}/lwasm", "--obj", "--output=foo.obj", "foo.asm"

    # lwlink
    system "#{bin}/lwlink", "--format=raw", "--output=foo.bin", "foo.obj"
    code = File.open("foo.bin", "rb") { |f| f.read.unpack("C*") }
    assert_equal [0xe7, 0x89, 0x12, 0x34], code

    # lwobjdump
    dump = `#{bin}/lwobjdump foo.obj`
    assert_equal 0, $CHILD_STATUS.exitstatus
    assert dump.start_with?("SECTION foo")

    # lwar
    system "#{bin}/lwar", "--create", "foo.lwa", "foo.obj"
    list = `#{bin}/lwar --list foo.lwa`
    assert_equal 0, $CHILD_STATUS.exitstatus
    assert list.start_with?("foo.obj")
  end
end
