class Lwtools < Formula
  desc "Cross-development tools for Motorola 6809 and Hitachi 6309"
  homepage "http://www.lwtools.ca/"
  url "http://www.lwtools.ca/releases/lwtools/lwtools-4.19.tar.gz"
  sha256 "427fec1571c876541895111536f3ccbd9243dd3b3d613f1a9e4b183d031ff681"
  license "GPL-3.0-only"

  livecheck do
    url "http://www.lwtools.ca/releases/lwtools/"
    regex(/href=.*?lwtools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18723cd8abac261f39994d5875b869c19ee4232cf86e2fd03ed83a71e9034baa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d732709205cfd87a92cb2486afdd6e4d5ac19fa01733a4d93d4c9615fa86c8a2"
    sha256 cellar: :any_skip_relocation, monterey:       "03a0ce78b03d83babeee81cfc256ff678c8ac8c40f2fcc1def0b5b52beb1542b"
    sha256 cellar: :any_skip_relocation, big_sur:        "978e2e47cdf8173352515110388b121e99ce8c5cba481a1b6233c3a2be5eb999"
    sha256 cellar: :any_skip_relocation, catalina:       "f83fea22c6690e876c3a3c36dbec9f8547551a591fadfde7a8741ff6dc23629f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79eb5e50e29e07a4654be549c3eb70aa2930ad8244bd65256d29f2d0c9b39982"
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
