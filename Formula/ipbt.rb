class Ipbt < Formula
  desc "Program for recording a UNIX terminal session"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/ipbt/"
  url "https://www.chiark.greenend.org.uk/~sgtatham/ipbt/ipbt-20170828.353928e.tar.gz"
  version "20170828"
  sha256 "7d520178e1cb487b7e6a458708f559f8618c1f3ef8cf88da419220a75f59b1fd"

  bottle do
    cellar :any_skip_relocation
    sha256 "e1622ed3848a14a34d77917007f7289015e4a2312491ebd5d157c5d0fb3558a3" => :sierra
    sha256 "c05d48bba404db1e7c5886f69af03ee781c29fb6c64c8bd071318603e249f000" => :el_capitan
    sha256 "f80314b01e1bad0114b24d2d0fb7d2e5f2a927b065065c6c7f02affec5e322c6" => :yosemite
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system "#{bin}/ipbt"
  end
end
