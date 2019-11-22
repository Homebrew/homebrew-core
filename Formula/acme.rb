class Acme < Formula
  desc "Crossassembler for multiple environments"
  homepage "https://sourceforge.net/projects/acme-crossass/"
  url "https://svn.code.sf.net/p/acme-crossass/code-0/trunk", :revision => "97"
  version "0.96.4"

  bottle do
    cellar :any_skip_relocation
    sha256 "2347f64662e48b99e1d200d9c9a1fa8442a4913c51fd87a4859ea70f7ddf23bd" => :catalina
    sha256 "529a7a699305f67a3443adcbd432a53690d314730401e970502222d2a2d7637b" => :mojave
    sha256 "95a02b54ddd935e3681b603617cdb428e3c0998697e83b5bacd231d0d662004f" => :high_sierra
    sha256 "3fea7e2943215c6e6ad2fa5be5e022d212b7fa55403a45f3b01a4bf5beba0061" => :sierra
    sha256 "c4dca010cb942fb1336b49ce754c2b90d61766cce34838214489bc64207f916c" => :el_capitan
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
