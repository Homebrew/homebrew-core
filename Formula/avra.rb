class Avra < Formula
  desc "Assember for the Atmel AVR microcontroller family"
  homepage "https://github.com/hsoft/avra"
  url "https://github.com/hsoft/avra/archive/1.4.0.tar.gz"
  sha256 "e343858feae0376e4bb34affc2e29ecccdb6f7c168a3925b4e95ff82549414e7"

  bottle do
    cellar :any_skip_relocation
    sha256 "671bb2170e315d95b430913fd8219222235e5c011411ed1985292fc0c2e4408f" => :mojave
    sha256 "0e394133e4af7b2ac8a8b038c7b1f6a18ab8b777df7e659f8581554e15f06c14" => :high_sierra
    sha256 "8866c6c99349c47f8a33249bfd96a09550068ef5c67f1913ad511a48b4561daf" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  # Crashes with 'abort trap 6' unless this fix is applied.
  # See: https://sourceforge.net/p/avra/patches/16/
  patch do
    url "https://gist.githubusercontent.com/adammck/7e4a14f7dd4cc58eea8afa99d1ad9f5d/raw/5cdbfe5ac310a12cae6671502697737d56827b05/avra-fix-osx.patch"
    sha256 "03493058c351cfce0764a8c2e63c2a7b691601dd836c760048fe47ddb9e91682"
  end

  def install
    # CDEFS is not passed when building for macOS. Fixed upstream, waiting for next release.
    # See: https://github.com/hsoft/avra/pull/1
    inreplace "src/makefiles/Makefile.osx", "$(CC) $(ARCH) -o avra $(SOURCE)", "$(CC) $(ARCH) $(CDEFS) -o avra $(SOURCE)"
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
