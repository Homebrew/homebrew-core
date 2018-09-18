class Ctunnel < Formula
  desc "Cryptographic or plain tunnels for TCP/UDP connections"
  homepage "https://github.com/alienrobotarmy/ctunnel"
  url "https://www.alienrobotarmy.com/ctunnel/0.7/ctunnel-0.7.tar.gz"
  sha256 "3c90e14af75f7c31372fcdeb8ad24b5f874bfb974aa0906f25a059a2407a358f"
  revision 1

  bottle do
    cellar :any
    sha256 "7d3debbf6a8fe8155e846e255e8330502a400c4d2da4d1c30c038fdbb9ba30cd" => :mojave
    sha256 "9a2394bdea7bf5ca99f5e92f6d99e8729fc6e81da0d6353f22cefe3e8df4baa4" => :high_sierra
    sha256 "dfcf3349529b7b2ab47298a9090d916be9eb3b9c0d72cd644f0e4b1de09796be" => :sierra
    sha256 "6a5de1059ec2e138e68530fd62f51b102e29d6ecfb83eaa22e3f79bc0d9acf4c" => :el_capitan
    sha256 "70736b739ab67933916bff1ce0d4ea9105c0faef9576646a5f7abf5e80f2b9b3" => :yosemite
    sha256 "3a442229dba723b14300c711e84b3dd0740b1b0488c6d4b59121193cba7195c7" => :mavericks
  end

  depends_on "openssl"

  def install
    # Do not require tuntap
    inreplace "Makefile.cfg", "TUNTAP=yes", "TUNTAP=no"

    system "make"
    bin.mkpath
    system "make", "-B", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/ctunnel", "-h"
  end
end
