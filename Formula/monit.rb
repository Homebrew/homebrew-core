class Monit < Formula
  desc "Manage and monitor processes, files, directories, and devices"
  homepage "https://mmonit.com/monit/"
  url "https://mmonit.com/monit/dist/monit-5.24.0.tar.gz"
  sha256 "754d1f0e165e5a26d4639a6a83f44ccf839e381f2622e0946d5302fa1f2d2414"

  bottle do
    sha256 "a809314a49449b1343dae188ab65a72909c91a5b550c27d9f6751c3b406ff57c" => :high_sierra
    sha256 "7eac548d6ffc36315e882e54a8375e6ebca368f4c988a36155091bf4993c90de" => :sierra
    sha256 "1587ccff153434fc11b371f719b497ddec1c4d90de09c652d637d6dab1422b35" => :el_capitan
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
