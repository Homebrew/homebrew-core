class Acme < Formula
  desc "Crossassembler for multiple environments"
  homepage "https://sourceforge.net/projects/acme-crossass/"
  url "https://svn.code.sf.net/p/acme-crossass/code-0/trunk", revision: "266"
  version "0.97"
  license "GPL-2.0-or-later"

  bottle do
    cellar :any_skip_relocation
    sha256 "fcf29880657324af51e378076ea9db3759aca5b443e84c77a81e91f56dc3bc78" => :catalina
    sha256 "484c4e81c9bd8e8440cf1eac1e704985b261fe2b08007cc25b482c528afff427" => :mojave
    sha256 "5adddcafac8c43eb3b287dc33f132e44e8c4e953a786fbb0b35343c4a9c0aa5d" => :high_sierra
  end

  def install
    system "make", "-C", "src", "install", "BINDIR=#{bin}"
    doc.install Dir["docs/*"]
  end

  test do
    path = testpath/"a.asm"
    path.write <<~EOS
      !to "a.out", cbm
      * = $c000
      jmp $fce2
    EOS

    system bin/"acme", path
    code = File.open(testpath/"a.out", "rb") { |f| f.read.unpack("C*") }
    assert_equal [0x00, 0xc0, 0x4c, 0xe2, 0xfc], code
  end
end
