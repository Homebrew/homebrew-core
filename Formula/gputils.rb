class Gputils < Formula
  desc "GNU PIC Utilities"
  homepage "http://gputils.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/gputils/gputils/1.5.0/gputils-1.5.0.tar.gz"
  sha256 "f6a517c186b991f504be5e4585316871d5950568257885d37487bb368dc76227"

  bottle do
    sha256 "2fde655a5fd6bf53e546b53458361cde8903257984b119559a3f054e56dc5913" => :sierra
    sha256 "e92667f348195c4500354273997257b3adca4d7f7a1d1b0a45b394d1f2cada85" => :el_capitan
    sha256 "0a6291a17acd99f297f0804a7f05bb175554bfb14e7c46fd19af7309817e628f" => :yosemite
    sha256 "fffd0d648d5df7f6c48385414ae5eae42abb33bd2d3d0485792ed8d4e7fb2359" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    # assemble with gpasm
    (testpath/"test.asm").write " movlw 0x42\n end\n"
    system "#{bin}/gpasm", "-p", "p16f84", "test.asm"
    assert File.exist?("test.hex")

    # disassemble with gpdasm
    output = shell_output("#{bin}/gpdasm -p p16f84 test.hex")
    assert_match "0000:  3042  movlw   0x42\n", output
  end
end
