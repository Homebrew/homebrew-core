class Ipbt < Formula
  desc "Program for recording a UNIX terminal session"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/ipbt/"
  url "https://www.chiark.greenend.org.uk/~sgtatham/ipbt/ipbt-20170829.a9b4869.tar.gz"
  version "20170829"
  sha256 "80b0c131ceec6f9fb36e551dfb8e63e993efdd2b33c063fd3d77bca32df36409"

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
