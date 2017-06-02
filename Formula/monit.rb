class Monit < Formula
  desc "Manage and monitor processes, files, directories, and devices"
  homepage "https://mmonit.com/monit/"
  url "https://mmonit.com/monit/dist/monit-5.22.0.tar.gz"
  mirror "https://fossies.org/linux/privat/monit-5.22.0.tar.gz"
  sha256 "9fc58b5e3caafd64f0b6fff3e65ae757239fab37d04fb33efce177da15176183"

  bottle do
    sha256 "98114c158836878037c85e128341aa36fceafe8b27985b92686a1bf01b566623" => :sierra
    sha256 "b5db2d084004b1a234a06023ee185d994f8791479283f7df7e698b511d3d619a" => :el_capitan
    sha256 "f404e855dcd18d29d3d7435ed74204abb0a35fd98f41bf6e8ad1145a845a44a3" => :yosemite
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
