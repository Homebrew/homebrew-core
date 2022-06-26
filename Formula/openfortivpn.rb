class Openfortivpn < Formula
  desc "Open Fortinet client for PPP+SSL VPN tunnel services"
  homepage "https://github.com/adrienverge/openfortivpn"
  url "https://github.com/adrienverge/openfortivpn/archive/v1.17.3.tar.gz"
  sha256 "60f319166fcbe8514dc7160346698ad83d8b09e2d4f5f011e16057bcfecf801f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_monterey: "5ca2db0441565444cfd32a7f425df65e1dbdbf5925173c3c75532e34ce4e7b54"
    sha256 arm64_big_sur:  "0ceb57978eba45f7dd5d84d7038853ea552b665e3f729396667fa9b0ded1f215"
    sha256 monterey:       "9e18c8c064ed26675eac8f2c804a6c96e764286ff55048bdd4cc1d80ce2ac59f"
    sha256 big_sur:        "d1b5968b54c9a081413fff6ccad29f1c2bd127bdb1b54e5b506f05d87471d54c"
    sha256 catalina:       "d36a4c7bf8b7458cf8841be4d6ad90972bd07671a9508c5b2067bee48fb7c318"
    sha256 x86_64_linux:   "af79810636c18a3f4bafafb8db4faa7de982ed9c213d17e3bb36ea60fef02e57"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}/openfortivpn"
    system "make", "install"
  end

  plist_options startup: true
  service do
    run [opt_bin/"openfortivpn", "-c", etc/"openfortivpn/openfortivpn/config"]
    keep_alive true
    log_path var/"log/openfortivpn.log"
    error_log_path var/"log/openfortivpn.log"
  end

  test do
    system bin/"openfortivpn", "--version"
  end
end
