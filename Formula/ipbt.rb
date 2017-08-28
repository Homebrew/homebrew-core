class Ipbt < Formula
  desc "Program for recording a UNIX terminal session"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/ipbt/"
  url "https://www.chiark.greenend.org.uk/~sgtatham/ipbt/ipbt-20170828.353928e.tar.gz"
  version "20170828"
  sha256 "7d520178e1cb487b7e6a458708f559f8618c1f3ef8cf88da419220a75f59b1fd"

  bottle do
    cellar :any_skip_relocation
    sha256 "7e079047d41d18157a1e964119afb834823145a066bd9bc7985f52619ff164b5" => :sierra
    sha256 "32256d5519da2500f23606f5ef39301b12fc26c07e7f6ec936150f50fb05befd" => :el_capitan
    sha256 "97973e8836e03fbf3577b7cb9376f141ee6d659d4ae1c2b48aec9dd8b330fc3d" => :yosemite
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
