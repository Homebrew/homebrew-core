class Dasm < Formula
  desc "Macro assembler with support for several 8-bit microprocessors"
  homepage "http://dasm-dillon.sourceforge.net"
  url "https://downloads.sourceforge.net/project/dasm-dillon/dasm-dillon/2.20.11/dasm-2.20.11-2014.03.04-source.tar.gz"
  sha256 "a9330adae534aeffbfdb8b3ba838322b92e1e0bb24f24f05b0ffb0a656312f36"
  head "svn://svn.code.sf.net/p/dasm-dillon/code/trunk"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "7425679bdb695c12ca174ca4f17e187a9a9aa5a92e7fe72bf8a561dd83aff4a7" => :sierra
    sha256 "854a19f232cffdeabb1cb2afef4a5713e55b545519beea8f666f2cc4882d42e6" => :el_capitan
    sha256 "1897ee7e4d76eeb74bd6aa3c94d73f14f55c44054dd296bbd724addb3ca3b00a" => :yosemite
    sha256 "3383c91ce64d715a05595e49d38d16ea134e139dc7b87541d8c81bf5a9aeaf15" => :mavericks
  end

  def install
    system "make"
    prefix.install "bin", "doc"
  end

  test do
    path = testpath/"a.asm"
    path.write <<-EOS
      processor 6502
      org $c000
      jmp $fce2
    EOS

    system bin/"dasm", path
    code = (testpath/"a.out").binread.unpack("C*")
    assert_equal [0x00, 0xc0, 0x4c, 0xe2, 0xfc], code
  end
end
