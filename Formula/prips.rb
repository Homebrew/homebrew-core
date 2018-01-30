class Prips < Formula
  desc "Print the IP addresses in a given range"
  homepage "https://devel.ringlet.net/sysutils/prips/"
  url "https://devel.ringlet.net/files/sys/prips/prips-1.0.2.tar.xz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/p/prips/prips_1.0.2.orig.tar.xz"
  sha256 "818258776fa981ea1e122051915a4cd3c777c542c89d23bf585712610abe4aed"

  bottle do
    cellar :any_skip_relocation
    sha256 "10f3802a208d576fc43ef60bdc37f610690fc2db3fd30af433ecce7df2992e90" => :high_sierra
    sha256 "7fd356876cb6ae47363d09405ac14e2dd129e51ded5b81603e9028132b96b86c" => :sierra
    sha256 "70eaa7f0bc91f0f6fbea259a2db276e15beea29ff4bd391f545bcb76b0588af1" => :el_capitan
    sha256 "37b66f0c4ccee70d7495e9f7bf822446214df33798af61b3e89ead65929de68b" => :yosemite
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
