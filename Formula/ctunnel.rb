class Ctunnel < Formula
  desc "Cryptographic or plain tunnels for TCP/UDP connections"
  homepage "https://github.com/alienrobotarmy/ctunnel"
  url "https://alienrobotarmy.com/ctunnel/0.7/ctunnel-0.7.tar.gz"
  sha256 "3c90e14af75f7c31372fcdeb8ad24b5f874bfb974aa0906f25a059a2407a358f"

  bottle do
    cellar :any
    revision 1
    sha256 "0efc6fd73d83e3b3d074f1819f439fce8ffa8e55434398c6e7446f7f51eb8aae" => :mavericks
  end

  depends_on "openssl"
  depends_on :tuntap => :recommended

  def install
    inreplace "Makefile.cfg", "TUNTAP=yes", "TUNTAP=no" if build.without? "tuntap"
    system "make"
    bin.mkpath
    system "make", "-B", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/ctunnel", "-h"
  end
end
