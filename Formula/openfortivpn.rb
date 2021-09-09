class Openfortivpn < Formula
  desc "Open Fortinet client for PPP+SSL VPN tunnel services"
  homepage "https://github.com/adrienverge/openfortivpn"
  url "https://github.com/adrienverge/openfortivpn/archive/v1.17.1.tar.gz"
  sha256 "c674c59cf3201a55d56cb503053982752fb641b13a85ea406b8a7e7df301e30f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_big_sur: "f35d76428149ed87f5402620e7116231e6a1434eaa64f798cf0d3607183270ff"
    sha256 big_sur:       "15cc82983644ac3e9abac3c5886877cf8cb434c9bfc5eb2c0fdac89844c06bd5"
    sha256 catalina:      "ad40158d78850d26983abe3d87550aacd5f06f48480338a74202dbb1c0b8b7fe"
    sha256 mojave:        "1de4a819a55e66ab4d90d738b1b8ee644949fa184683583201a423a2a8cc0bf8"
    sha256 x86_64_linux:  "74c86dcb84898ec512231e13f3d96047de42b6b693c4fd57b3ac9ff8c042f599"
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
  test do
    system bin/"openfortivpn", "--version"
  end
end
