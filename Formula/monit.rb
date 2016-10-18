class Monit < Formula
  desc "Manage and monitor processes, files, directories, and devices"
  homepage "https://mmonit.com/monit/"
  url "https://mmonit.com/monit/dist/monit-5.19.0.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main//m/monit/monit_5.19.0.orig.tar.gz"
  sha256 "befcd54365502bce4ffd6d1b0c345d5b689c9f7cb3a35a462ba7dcffcf6f62b8"

  bottle do
    cellar :any
    sha256 "cd4622ecbb475cc9ee10613714fc59d7b200ccabbf7d73c978783f3b7b0145aa" => :sierra
    sha256 "5a146e27154d2434cfb44dbd61ae55b7ed8fa01bd105cf0bc5828bf90a7252b7" => :el_capitan
    sha256 "924ec6e8d44fa5168442431f5ba61724243196929e7a18d1a936f4b9a99035c1" => :yosemite
    sha256 "25be7ac4a24e829b081d562c0249e2c4a48d77a49e9f5c3f49a609023d702fc5" => :mavericks
  end

  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--localstatedir=#{var}/monit",
                          "--sysconfdir=#{etc}/monit",
                          "--with-ssl-dir=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
    pkgshare.install "monitrc"
  end

  test do
    system bin/"monit", "-c", pkgshare/"monitrc", "-t"
  end
end
