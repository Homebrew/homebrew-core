class Avra < Formula
  desc "Assember for the Atmel AVR microcontroller family"
  homepage "https://github.com/hsoft/avra"
  url "https://github.com/hsoft/avra/archive/1.4.1.tar.gz"
  sha256 "0b92f3a2709d72b903fd95afee2c985ed3847440ad12cd651738afffa14ec69e"

  bottle do
    cellar :any_skip_relocation
    sha256 "671bb2170e315d95b430913fd8219222235e5c011411ed1985292fc0c2e4408f" => :mojave
    sha256 "0e394133e4af7b2ac8a8b038c7b1f6a18ab8b777df7e659f8581554e15f06c14" => :high_sierra
    sha256 "8866c6c99349c47f8a33249bfd96a09550068ef5c67f1913ad511a48b4561daf" => :sierra
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
