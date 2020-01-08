class Monit < Formula
  desc "Manage and monitor processes, files, directories, and devices"
  homepage "https://mmonit.com/monit/"
  url "https://mmonit.com/monit/dist/monit-5.26.0.tar.gz"
  sha256 "87fc4568a3af9a2be89040efb169e3a2e47b262f99e78d5ddde99dd89f02f3c2"
  revision 1

  bottle do
    cellar :any
    sha256 "8d458edfa882fb548687207ad596b0514a1a97b3946b518986dcae487289c74a" => :catalina
    sha256 "ef1b1dfc18ef4b3e570c085df6ad526f2556dec0d1f9f8f37ecc46c85fb0c23f" => :mojave
    sha256 "e87f450a96b87b7fa3d4d5fa4556b6ecf9a31f7f71bcbd23329d8a413aa2f127" => :high_sierra
    sha256 "5ba37a630257fb070648d1eb7117b94e31dd8f30f3ca351098192dc4974e9ca4" => :sierra
  end

  depends_on "openssl@1.1"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--localstatedir=#{var}/monit",
                          "--sysconfdir=#{etc}/monit",
                          "--with-ssl-dir=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
    pkgshare.install "monitrc"
  end

  test do
    system bin/"monit", "-c", pkgshare/"monitrc", "-t"
  end
end
