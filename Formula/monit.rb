class Monit < Formula
  desc "Manage and monitor processes, files, directories, and devices"
  homepage "https://mmonit.com/monit/"
  url "https://mmonit.com/monit/dist/monit-5.24.0.tar.gz"
  sha256 "754d1f0e165e5a26d4639a6a83f44ccf839e381f2622e0946d5302fa1f2d2414"

  bottle do
    sha256 "a47f0d5849393a5ed8b07e18e8902655db30f9560947f168ef00f4c15812c475" => :high_sierra
    sha256 "d68ced7b1d9107185c9cf2bc70ada98af5e6c7dcb3a4b4da6d82fda6659cb34a" => :sierra
    sha256 "5cedb7d2decc2d9eaf16868075a4f47f09f4dfaea8a6ac3f8b80d49865aaf6ec" => :el_capitan
    sha256 "7dec7fe801ad4afcf615dfd55e3025a01cf1511c0b70a096d1b98e087274ac7f" => :yosemite
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
