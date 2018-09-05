class Monit < Formula
  desc "Manage and monitor processes, files, directories, and devices"
  homepage "https://mmonit.com/monit/"
  url "https://mmonit.com/monit/dist/monit-5.25.2.tar.gz"
  sha256 "aa0ce6361d1155e43e30a86dcff00b2003d434f221c360981ced830275abc64a"

  bottle do
    sha256 "296fd100f547f2df58a8f20586482ba999175c6cf6e1ce105887e083da3e5a12" => :mojave
    sha256 "7e7a2b1afea349b49e0cc7c9cfae1ccf8b636ec8e69295484670203571c41a26" => :high_sierra
    sha256 "63cefa0ddab53d22e2fce73ac0d2bf23a9c9a2747384182e1004563e2e28d95e" => :sierra
    sha256 "87d743b3df524371a597fae5f255779e1928ed0b90eb2e755d493f8a54e33abf" => :el_capitan
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
