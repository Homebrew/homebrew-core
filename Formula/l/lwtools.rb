class Lwtools < Formula
  desc "Cross-development tools for Motorola 6809 and Hitachi 6309"
  homepage "http://www.lwtools.ca/"
  url "http://www.lwtools.ca/releases/lwtools/lwtools-4.23.tar.gz"
  sha256 "f05255516783ea5b118e7e32e8e4d420b6835864c2833ecde3477b4be19db038"
  license "GPL-3.0-only"

  livecheck do
    url "http://www.lwtools.ca/releases/lwtools/"
    regex(/href=.*?lwtools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "eab3dfe12c7aeb0bf11de4c44d983b9f8fa8d6145738f440ff69bb93971a522c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "006c60eee04ec235ed358e0395e992d9158610fecba2f5b668af81b5c3e6ab74"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "182534ce1b37a6230553cee3d3e794629a0e885ab762c621eb47b59bc055e8ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa3093f31f2365fd394d4f5785c12cc8fe38b8e7e99b53d422ac5b1dade6fa82"
    sha256 cellar: :any_skip_relocation, sonoma:         "f0285e0f21559766bc595222d32c1e5a49495d0eb0bc13596152fd16e2112d2e"
    sha256 cellar: :any_skip_relocation, ventura:        "e3a03360ee1f0c8a452f8b070724401adeadd46730174ba53786b4d645f1bea9"
    sha256 cellar: :any_skip_relocation, monterey:       "cee52e52672b605b4a38d6596cc2fa7a0613bea352a47f86ec27e2123bb73a3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fdd3cffd56bce4bb757bcfc522d20df58e10abf0148960f5db0d3c3f8ae6adc"
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
    dump = `#{bin}/lwobjdump foo.obj`
    assert_equal 0, $CHILD_STATUS.exitstatus
    assert dump.start_with?("SECTION foo")

    # lwar
    system bin/"lwar", "--create", "foo.lwa", "foo.obj"
    list = `#{bin}/lwar --list foo.lwa`
    assert_equal 0, $CHILD_STATUS.exitstatus
    assert list.start_with?("foo.obj")
  end
end
