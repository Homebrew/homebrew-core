class Gputils < Formula
  desc "GNU PIC Utilities"
  homepage "https://gputils.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/gputils/gputils/1.5.0/gputils-1.5.2.tar.bz2"
  sha256 "8fb8820b31d7c1f7c776141ccb3c4f06f40af915da6374128d752d1eee3addf2"
  license "GPL-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/gputils[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "973d66004e773aa92968ddcfd79781b1eead7689771fe5c0629241a77b625e26"
    sha256 arm64_monterey: "ef9e856e54329ca707dbcda0c51cd85f2351a73de705f614f5936cc71baee4ad"
    sha256 arm64_big_sur:  "7c7d6f710f0b5d41014b34fc022e88007a508a185b4c12cc0c51ea3d26be58dc"
    sha256 ventura:        "dee33ce7d2ec0e90877801f33554fc3bb824c7ce2c3128ea3037af276c61eeb6"
    sha256 monterey:       "0033e9463df7f37295cf89c23335763769a2df27bcfd61121121467028922054"
    sha256 big_sur:        "7c3aefbcf78392080e05773e9e9ef9c289f15bd9e02b9e7f33ecae7cc2ccf3df"
    sha256 catalina:       "80ca3e7c4b44a63ef25b476ec5fbaf25381d82d48e2ba33eda91b0b70fb4fcd3"
    sha256 x86_64_linux:   "980a09d45f616f560b368078822553d130d7630b813d92696fd15f894593bf4b"
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
