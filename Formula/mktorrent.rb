class Mktorrent < Formula
  desc "Create BitTorrent metainfo files"
  homepage "https://mktorrent.sourceforge.io/"
  url "https://github.com/Rudde/mktorrent/archive/v1.1.tar.gz"
  sha256 "d0f47500192605d01b5a2569c605e51ed319f557d24cfcbcb23a26d51d6138c9"

  bottle do
    cellar :any
    sha256 "9edd5b41e870ca716bad213d2ecf095e1d33b124ff150952fafc8a0d4dfd4560" => :sierra
    sha256 "6b11723fa40237afee4a17781b51c0cf6be510c3df02bca72cd5f6a299e22f24" => :el_capitan
    sha256 "d0f3f1d677e34044abcd712163c01008b56391d665daad15911acd446255c88a" => :yosemite
  end

  depends_on "openssl"

  def install
    system "make", "USE_PTHREADS=1", "USE_OPENSSL=1", "USE_LONG_OPTIONS=1"
    bin.install "mktorrent"
  end
end
