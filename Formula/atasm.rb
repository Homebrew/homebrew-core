class Atasm < Formula
  desc "Atari MAC/65 compatible assembler for Unix"
  homepage "https://atari.miribilist.com/atasm/"
  url "https://atari.miribilist.com/atasm/atasm107d.zip"
  version "1.07d"
  sha256 "24a165506346029fbe05ed99b22900ae50f91f5a8c5d38ebad6a92a5c53f3d99"

  def install
    cd "src" do
      system "make", "prog"
      bin.install "atasm"
      system "sed -e 's,%%DOCDIR%%,/usr/local/share/doc/atasm,g' < atasm.1.in > atasm.1"
      man1.install "atasm.1"
    end
    doc.install "examples"
  end

  test do
    cd "#{doc}/examples" do
      system "#{bin}/atasm", "-v", "test.m65", "-o/tmp/test.bin"
    end
  end
end
