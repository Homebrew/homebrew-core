class Lwtools < Formula
  desc "Cross-development tools for Motorola 6809 and Hitachi 6309"
  homepage "http://www.lwtools.ca/"
  url "http://www.lwtools.ca/releases/lwtools/lwtools-4.22.tar.gz"
  sha256 "94a176c9d567f5cec49800b85ac16e71fffafdfdfefecb15bcf5d784da19301b"
  license "GPL-3.0-only"

  livecheck do
    url "http://www.lwtools.ca/releases/lwtools/"
    regex(/href=.*?lwtools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a2ad82880cdaf430c1a6cb8cc0967ee462a08fe2e885164ee6c0899de8bad98a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "40d9100d649ffea01cbec14d80dfbd83857a9edb61b664989515fa5c23ed5096"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb64b8975b1402a2af702bd457df96d27350ced878db318e2b0ab4510ed68300"
    sha256 cellar: :any_skip_relocation, sonoma:         "4e9d67a63b0cd3a5adbac768a68fb3fbd8f0155e34ed5a5c0ae695261891881e"
    sha256 cellar: :any_skip_relocation, ventura:        "9d76a2b8720b0d05ffc95132f5b5ed183457c31444e69409eeaf5b9d5c5b6307"
    sha256 cellar: :any_skip_relocation, monterey:       "8ea725e062a165d5d4f3df655b63f38a3fbab40494d63fa3423bba54ddc43c6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae5b1cd10c09de50762dff9b984d7092e772ddf5c7d5b5e9b1992cea174e35d7"
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
