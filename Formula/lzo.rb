class Lzo < Formula
  desc "Real-time data compression library"
  homepage "https://www.oberhumer.com/opensource/lzo/"
  url "https://www.oberhumer.com/opensource/lzo/download/lzo-2.10.tar.gz"
  sha256 "c0f892943208266f9b6543b3ae308fab6284c5c90e627931446fb49b4221a072"

  bottle do
    cellar :any
    sha256 "581c458fc439bad0ccd07e7d7fa4215e0160c75148b2637986b50168e92a6b79" => :sierra
    sha256 "b5838b31508dea737a64b8e01be586004c5d51cece7c89808014855d23a7a48a" => :el_capitan
    sha256 "27ec3d9e9303bab8aedb74eb617b147f92e34251c0a3da2fba9004f3d76ea96f" => :yosemite
    sha256 "af6941abe4f2a8db33e5a8296352b4cf0ef4df73152e8f968efa59b7213a5969" => :mavericks
    sha256 "d9ccb8e665598254f96907a1716760af99736771f41be2f31ab47c6409017251" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-shared"
    system "make"
    system "make", "check"
    system "make", "install"
  end
end
