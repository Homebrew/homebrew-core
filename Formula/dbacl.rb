class Dbacl < Formula
  desc "Digramic Bayesian classifier"
  homepage "http://dbacl.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/dbacl/dbacl/1.14.1/dbacl-1.14.1.tar.gz"
  sha256 "ff0dfb67682e863b1c3250acc441ce77c033b9b21d8e8793e55b622e42005abd"

  bottle do
    cellar :any_skip_relocation
    sha256 "c6e6d74e2f2a86325ee895f8ef6893d99e1463d0018ead0d0da46e0dfd95c272" => :sierra
    sha256 "750c29761c5784ddbd0d46643f2d462d8b22c14822773e2366db01be17a3e310" => :el_capitan
    sha256 "b3d759bba5d1e478bc3df9e829594f49fb37cdd96e589937ebf4a7da87416855" => :yosemite
    sha256 "09d4e7e62bc73cf25f16d366c768519e10f3ce33894c4a7eaa327046cc05889a" => :mavericks
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
