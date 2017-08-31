class Ipbt < Formula
  desc "Program for recording a UNIX terminal session"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/ipbt/"
  url "https://www.chiark.greenend.org.uk/~sgtatham/ipbt/ipbt-20170831.3c40fd3.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/ipbt-20170831.tar.gz"
  version "20170831"
  sha256 "237394f7074a8e540495bdcb8b82b5a932f8597505e2ee3ba3d96b0671cfeae3"

  bottle do
    cellar :any_skip_relocation
    sha256 "f9dd24a2a7bd67ee00a4763b6931975f27443d906d91795962ca8a1eb647d269" => :sierra
    sha256 "3ebaf07effeb98490201a2c8cc38bfdaec25c0db5a6bf3f2936f72b944ee5309" => :el_capitan
    sha256 "511b256cd2f9eda3db809f2a46c47ed72c7a4fadef4fb16bb5197766cc966fe9" => :yosemite
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
