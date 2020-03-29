class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.3.0.tar.gz"
  sha256 "7a007d655d30f1edd001206839107e651966e1e519d53ba2c036491044111e97"

  bottle do
    sha256 "07d7fdac349bb1f35b746247f29b97e2379f9d19fd66cc6e1a81c6b5641c2b7d" => :catalina
    sha256 "e43570ffacdf14e58a5d80d955cd154b17ab4b5f4558b120b8d694733aa6e539" => :mojave
    sha256 "1e402a7ed8f5fbf048dd855072c38826f549d20af621f5829bab4a12422ab233" => :high_sierra
  end

  depends_on "libevent"
  depends_on "openssl@1.1"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--with-libevent=#{Formula["libevent"].opt_prefix}",
                          "--with-ssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{sbin}/nsd", "-v"
  end
end
