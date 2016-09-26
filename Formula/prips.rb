class Prips < Formula
  desc "Print the IP addresses in a given range"
  homepage "https://devel.ringlet.net/sysutils/prips/"
  url "https://devel.ringlet.net/files/sys/prips/prips-1.0.0.tar.xz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/p/prips/prips_1.0.0.orig.tar.xz"
  sha256 "d588b0dac6d740a07357f2c2f149dcae4cda479f047b761268ab51185cad53b7"

  bottle do
    cellar :any_skip_relocation
    sha256 "9ef97b52d486c21c9c2c615406f542faac38c75f3d423504fcf467dacf08a9cf" => :sierra
    sha256 "95874b20461b96d9ec060ced0f23ad1d22ac30818341ff8fa2380794d5859a08" => :el_capitan
    sha256 "0787a633740c3b76506e0f10fb38d3864f4d1d47c132026a457103ee7497706a" => :yosemite
    sha256 "7be9562a3f537dcce9e8ab394f536bad25a9c4d3c5b069f697fb4567a9a60e93" => :mavericks
  end

  def install
    system "make"
    bin.install "prips"
    man1.install "prips.1"
  end

  test do
    assert_equal "127.0.0.0\n127.0.0.1",
      shell_output("#{bin}/prips 127.0.0.0/31").strip
  end
end
