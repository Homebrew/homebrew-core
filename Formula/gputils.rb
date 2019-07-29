class Gputils < Formula
  desc "GNU PIC Utilities"
  homepage "https://gputils.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/gputils/gputils/1.5.0/gputils-1.5.0-1.tar.bz2"
  sha256 "6f88a018e85717b57a22f27a0ca41b2157633a82351f7755be92e2d7dc40bb14"

  bottle do
    sha256 "94ddaac79ac5d6cfdddbd588fbb2ccd8be3f5a62662fe64d19a63828d8b6d305" => :mojave
    sha256 "c5ed95fc323471f635edbc08e81394f66486c4c81953a0881c5b26791d1176bb" => :high_sierra
    sha256 "aba5cb544582e26bdb212f9782f911b0e9d36c5049d0aed3928c48ae9b74a6e9" => :sierra
    sha256 "ad3a6688ca0dac1da0a10db36d9119d9bedcd8d0f389920a45832cc0676c67a3" => :el_capitan
    sha256 "dd69717c349e405ed04eebc07fc86dcc09d3763f892488514528b328a725a3f9" => :yosemite
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    # assemble with gpasm
    (testpath/"test.asm").write " movlw 0x42\n end\n"
    system "#{bin}/gpasm", "-p", "p16f84", "test.asm"
    assert_predicate testpath/"test.hex", :exist?

    # disassemble with gpdasm
    output = shell_output("#{bin}/gpdasm -p p16f84 test.hex")
    assert_match "0000:  3042  movlw   0x42\n", output
  end
end
