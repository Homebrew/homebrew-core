class Puf < Formula
  desc "Parallel URL fetcher"
  homepage "http://puf.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/puf/puf/1.0.0/puf-1.0.0.tar.gz"
  sha256 "3f1602057dc47debeb54effc2db9eadcffae266834389bdbf5ab14fc611eeaf0"

  bottle do
    cellar :any_skip_relocation
    sha256 "3153e22f42620f0ceb69f11080e6ba113765d7847cbbb2672f30a7a6766db972" => :sierra
    sha256 "24952b79335eb08d7a8880a16714e6afe3b73a65f5f26c59b106020198c1b3f3" => :el_capitan
    sha256 "d96385896fd7831b71af3b05d55f3c5cd2c3a9565f9083c2efe96309989dcf15" => :yosemite
    sha256 "7b76565452fb4f2b03a8b01d6e7495634965ba0bad74906cb907c0642805e5e5" => :mavericks
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end
