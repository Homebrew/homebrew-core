class Lwtools < Formula
  desc "Cross-development tools for Motorola 6809 and Hitachi 6309"
  homepage "http://lwtools.projects.l-w.ca/"
  url "http://lwtools.projects.l-w.ca/releases/lwtools/lwtools-4.14.tar.gz"
  sha256 "34d4b440615954d3e06fc15066bd6e9985c79b4e0c1675e8ac3aa8d0166ef9e5"

  bottle do
    cellar :any_skip_relocation
    sha256 "5a96b0c26f79b3c829682787bb3417915165ede98b03cd3930f702f5de7d505c" => :high_sierra
    sha256 "cd48eff4a17ae3af580ab16883e56746d5e9037e85ca3115daed1319509441a3" => :sierra
    sha256 "f79d18b3454c1c117d3103195b4026ada7306eb32cc0773fed95ab3b598140f9" => :el_capitan
  end

  def install
    system "make"
    system "make", "install", "INSTALLDIR=#{bin}"
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
