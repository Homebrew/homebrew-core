class Faad2 < Formula
  desc "ISO AAC audio decoder"
  homepage "http://www.audiocoding.com/faad2.html"
  url "https://downloads.sourceforge.net/project/faac/faad2-src/faad2-2.8.0/faad2-2.8.1.tar.gz"
  sha256 "133270a9be0c9ab8fea18017703ab4a94f9eddbb45a8aa6a511a1469fa413591"

  bottle do
    cellar :any
    rebuild 1
    sha256 "dc0b4f69ac5ccb338c409fbce248f2d45dae4e706ef67bb3ae4aa865c7d67b55" => :sierra
    sha256 "ded931642921a5e0d236237ce046f883aa96a0e5bfe67f5d437ee31f10b5f3d1" => :el_capitan
    sha256 "c9d4798cb9ed59d6f4b9e5fa24d65e4b9afca6a390b4e0d4168975a0da43b991" => :yosemite
    sha256 "4d5c07adef1f8fbeea4e71ad42205145b38dd3e3616485b9ee44f839c6d4f1a4" => :mavericks
    sha256 "cc0b789cd93b14247f679211b2f4a592e88395304cb6cc1df91514ed9d6a9720" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    man1.install man+"manm/faad.man" => "faad.1"
  end
end
