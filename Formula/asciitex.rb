class Asciitex < Formula
  desc "Generate ASCII-art representations of mathematical equations"
  homepage "https://asciitex.sourceforge.io"
  url "https://downloads.sourceforge.net/project/asciitex/asciiTeX-0.21.tar.gz"
  sha256 "abf964818833d8b256815eb107fb0de391d808fe131040fb13005988ff92a48d"

  bottle do
    cellar :any_skip_relocation
    sha256 "4899775d92a5f26e4b8530823593e5819b8578c44a4537c949ee4e0f6f3d5614" => :catalina
    sha256 "d5f864f9e6722d36da2e0412d4523a4977599c1229e3fb122bf4a0b29421c082" => :mojave
    sha256 "28a1327d58e05b74df8382ce37595d8d80decaf5cdbac4739995bc53d9f30ef7" => :high_sierra
    sha256 "9828783530514218f99ea7eabfad2031caeac979fac90cc9e049de4b4622fb80" => :sierra
    sha256 "0ae267d7ffcf17769da97275af047dc2a4ba9e5086acdb53dd11ca41f3d40ddb" => :el_capitan
    sha256 "e9eadc960e449db67f305c3e1cc8d4f025288967bb8b6a37f5ba4bf5ad58493d" => :yosemite
    sha256 "31518a63d9b06f8e47ff57c5d6d22ca838abc2c1366d59db2bb8967971134d52" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-gtk"
    inreplace "Makefile", "man/asciiTeX_gui.1", ""
    system "make", "install"
    pkgshare.install "EXAMPLES"
  end

  test do
    system "#{bin}/asciiTeX", "-f", "#{pkgshare}/EXAMPLES"
  end
end
