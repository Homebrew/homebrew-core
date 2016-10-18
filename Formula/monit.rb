class Monit < Formula
  desc "Manage and monitor processes, files, directories, and devices"
  homepage "https://mmonit.com/monit/"
  url "https://mmonit.com/monit/dist/monit-5.19.0.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main//m/monit/monit_5.19.0.orig.tar.gz"
  sha256 "befcd54365502bce4ffd6d1b0c345d5b689c9f7cb3a35a462ba7dcffcf6f62b8"

  bottle do
    cellar :any
    sha256 "fd7408fc598000d81c294125645de093951747a27383e7d78ea49e60a70b9864" => :sierra
    sha256 "1a477a903f166904ff7105062f5ec35494d65c235e056e4caffe5b486e833869" => :el_capitan
    sha256 "ec3d67f372b43df39477358de470c652ff29a0c8b76c55536083518c0c684382" => :yosemite
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
