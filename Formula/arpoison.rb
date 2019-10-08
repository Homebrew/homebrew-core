class Arpoison < Formula
  desc "UNIX arp cache update utility"
  homepage "http://www.arpoison.net/"
  url "http://www.arpoison.net/arpoison-0.7.tar.gz"
  sha256 "63571633826e413a9bdaab760425d0fab76abaf71a2b7ff6a00d1de53d83e741"

  bottle do
    cellar :any
    rebuild 1
    sha256 "21f8aabff068436f9fd942ef7ec4fac4dda3f675efa2feaf3120283a6dded2f1" => :catalina
    sha256 "85237acdcba092c948cd45c98ad0e9fdfea757d155e7a464a8379fee5b9420a8" => :mojave
    sha256 "eb37399841022351ef5551de5a63ecfc93d061d03518d62f01852a1d8e663e4e" => :high_sierra
    sha256 "2ed60cb186440c24eaf0c8e040acb89ba60cdd730c83f4c6793add25c80a67ca" => :sierra
    sha256 "33e496f9d1ca384ad23c50a1868fc2682352176d1cf5b37472299a9e36dc7e6c" => :el_capitan
    sha256 "9d902ac3611dd0422783aecb7d46f39dd0278f65f5cab1aa99490fb527de5e22" => :yosemite
    sha256 "0737a954fa5f4d6794f7a373b90b5d2b2008a0bf7cdc4e2fd51266485e86b983" => :mavericks
  end

  depends_on "libnet"

  def install
    system "make"
    bin.install "arpoison"
    man8.install "arpoison.8"
  end

  test do
    # arpoison needs to run as root to do anything useful
    assert_match "target MAC", shell_output("#{bin}/arpoison", 1)
  end
end
