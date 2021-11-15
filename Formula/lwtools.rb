class Lwtools < Formula
  desc "Cross-development tools for Motorola 6809 and Hitachi 6309"
  homepage "http://www.lwtools.ca/"
  url "http://www.lwtools.ca/releases/lwtools/lwtools-4.18.tar.gz"
  sha256 "1f7837d4985f2f3db65bd7c1af05ab7fc779ca43c8bbe411a3042fd85f0c8151"
  license "GPL-3.0-only"

  livecheck do
    url "http://www.lwtools.ca/releases/lwtools/"
    regex(/href=.*?lwtools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51911838e7c002f6d824d58a89837ce650beb4e03d53460ab3f5c3da1dd50aa6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b69e842ed193a65a877890c6a25cf80b610b0ba9c63403721e69713894168203"
    sha256 cellar: :any_skip_relocation, monterey:       "e915da370c74887b7f1d0c3fcae3bb6fd5fe0868456ff6ab6c8602e96e563e47"
    sha256 cellar: :any_skip_relocation, big_sur:        "f8c0301704cd912e73419d49ac9d277b57d46cfa5dc7019c74bf12944a88dc75"
    sha256 cellar: :any_skip_relocation, catalina:       "412734981bb998d93accd7f4401ff21c6f9e2b33028c39c9e80e7651e19bed79"
    sha256 cellar: :any_skip_relocation, mojave:         "3f7c5497c74bb6f616e243d5d8f61d0f7365c6949148f558397d8798dda5bdd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "621fac2dcd0fe3cde337f666e109737aacb9ad3fcd5f5050a4625d311274ed04"
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
