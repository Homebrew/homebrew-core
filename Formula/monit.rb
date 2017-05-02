class Monit < Formula
  desc "Manage and monitor processes, files, directories, and devices"
  homepage "https://mmonit.com/monit/"
  url "https://mmonit.com/monit/dist/monit-5.21.0.tar.gz"
  mirror "https://fossies.org/linux/privat/monit-5.21.0.tar.gz"
  sha256 "fbf76163ed4a180854d378af60fed0cdbc5a8772823957234efc182ead10c03c"

  bottle do
    sha256 "cf5fe0d85c03d64e0d1f213c76f70d25df9856b93f60cd5e4facc13d271e1cd6" => :sierra
    sha256 "55f803929e1f12950d7f2ac0b373ba10a6aac7895a3b03f63c22eb0927c02673" => :el_capitan
    sha256 "618b1981e0b7b71ec787ced7d321c9d4c6cfc0cf16774d962fea2302b92dd74d" => :yosemite
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
