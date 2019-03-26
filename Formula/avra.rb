class Avra < Formula
  desc "Assember for the Atmel AVR microcontroller family"
  homepage "https://github.com/hsoft/avra"
  url "https://github.com/hsoft/avra/archive/1.4.0.tar.gz"
  sha256 "e343858feae0376e4bb34affc2e29ecccdb6f7c168a3925b4e95ff82549414e7"

  bottle do
    cellar :any_skip_relocation
    sha256 "e24312ed64192fa3e90f497d6f37eee1f9a3cb9505f943018f28c29b8ce2c044" => :mojave
    sha256 "0c4ac95218144b45bfed147a584707c8f2b8f0ec7c75b2ac4fdfae5592029b92" => :high_sierra
    sha256 "2fd31c2a27b2ef237a6c9e33d7b378682dcba6b79131717f6c97264999b85658" => :sierra
    sha256 "a53990c229653465948d9d66fc972e695591cddf6529c25ad834fed7fbd7267d" => :el_capitan
    sha256 "1fd6d746309dbdf2811ba8d461188ec63e93363a34546a3af7ad9b4f47c75ffc" => :yosemite
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
