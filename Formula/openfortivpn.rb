class Openfortivpn < Formula
  desc "Open Fortinet client for PPP+SSL VPN tunnel services"
  homepage "https://github.com/adrienverge/openfortivpn"
  url "https://github.com/adrienverge/openfortivpn/archive/v1.20.3.tar.gz"
  sha256 "e54331098dc2c009cf98524f0ade027e337739506c5a60b65e2c2bf5f9c1d7e1"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }

  bottle do
    sha256 arm64_ventura:  "655f8bfb531d5d7a11b99aa8396a953b0fff3d243aaf7b98a8d897f77499ce1c"
    sha256 arm64_monterey: "7ba8849ff7942da7c5b79a721e47945c6432e7ddfc362d435f0fb174bca629f0"
    sha256 arm64_big_sur:  "6838988583fb7050d8993c93dca554d8c8f3e940d6811ed16c89981e2e5d606a"
    sha256 ventura:        "861e25b4e5afb835e42b90f98582ac570dea2fe657f0e8e3531e8b53efacf713"
    sha256 monterey:       "8e00a5640873be20b5cdb6f8915c7701bd4fa12f8fe28f5dacea9ee63244b37f"
    sha256 big_sur:        "612a13fbb8c9373fb90c629a6ec87d2df73329d08ba4757940a4be1c61234687"
    sha256 x86_64_linux:   "317d3c3ab8de9b4a6820d5453748503e48902d5733b68099a817754af0fd0df6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@3"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}/openfortivpn"
    system "make", "install"
  end

  service do
    run [opt_bin/"openfortivpn", "-c", etc/"openfortivpn/openfortivpn/config"]
    keep_alive true
    require_root true
    log_path var/"log/openfortivpn.log"
    error_log_path var/"log/openfortivpn.log"
  end

  test do
    system bin/"openfortivpn", "--version"
  end
end
