class Dcfldd < Formula
  desc "Enhanced version of dd for forensics and security"
  homepage "http://dcfldd.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/dcfldd/dcfldd/1.3.4-1/dcfldd-1.3.4-1.tar.gz"
  sha256 "f5143a184da56fd5ac729d6d8cbcf9f5da8e1cf4604aa9fb97c59553b7e6d5f8"

  bottle do
    cellar :any_skip_relocation
    sha256 "0958d948042f047d4249a7400f8c4f7adfe41f11c20aa04a0dbaac09c718ea2a" => :sierra
    sha256 "0d5ff357d74fa90a97d80e202ddb5b5554bfec35efa2c4cb6e0f7e6dc9cf8ece" => :el_capitan
    sha256 "4731a1409199c0eb8d83f9f2f23106c1f71ccb1f8d8faf71a3fd691ba394791f" => :yosemite
    sha256 "5aeedb1165a426057dce57cf8b9b5b33db33f502d8cf2611276f2526bde1dda4" => :mavericks
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end
