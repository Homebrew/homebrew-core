class Avra < Formula
  desc "Assember for the Atmel AVR microcontroller family"
  homepage "https://github.com/hsoft/avra"
  url "https://github.com/hsoft/avra/archive/1.4.1.tar.gz"
  sha256 "0b92f3a2709d72b903fd95afee2c985ed3847440ad12cd651738afffa14ec69e"

  bottle do
    cellar :any_skip_relocation
    sha256 "97a934f11ada79ed1b37a74a6e726445150edb713f2520c2d0c5131fca2f36b6" => :catalina
    sha256 "8d75188d31649e471e5851df65c723016924a08307b6560cfa855379a7169b1c" => :mojave
    sha256 "401635c4cf252ba0d19ed77866748d3d3deb05a6f024f3aa3c8bfbba69eba8f3" => :high_sierra
    sha256 "0c349d7192c3eb3b3ba63fc26efb3ea2ca58de6160747804da51ee85c7cc98b5" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}", "OS=osx"
    pkgshare.install Dir["includes/*"]
  end

  test do
    (testpath/"test.asm").write " .device attiny10\n ldi r16,0x42\n"
    output = shell_output("#{bin}/avra -l test.lst test.asm")
    assert_match "Assembly complete with no errors.", output
    assert_predicate testpath/"test.hex", :exist?
    assert_match "ldi r16,0x42", File.read("test.lst")
  end
end
