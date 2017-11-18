class Monit < Formula
  desc "Manage and monitor processes, files, directories, and devices"
  homepage "https://mmonit.com/monit/"
  url "https://mmonit.com/monit/dist/monit-5.25.1.tar.gz"
  sha256 "4b5c25ceb10825f1e5404f1d8a7b21507716b82bc20c3586f86603691c3b81bc"

  bottle do
    sha256 "f4c7174fa4f4dd3fce8adf34e74f42070141da499f1cd685486d1720a832a2bd" => :high_sierra
    sha256 "7fd046172b37dd30581620793d86811b64363247bf2d33081aa761f99df8cafb" => :sierra
    sha256 "7cb908a88961818fb1b54ac071943d46578c7b7a180ceed8e6fc40c02298316a" => :el_capitan
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
