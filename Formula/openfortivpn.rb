class Openfortivpn < Formula
  desc "Open Fortinet client for PPP+SSL VPN tunnel services"
  homepage "https://github.com/adrienverge/openfortivpn"
  url "https://github.com/adrienverge/openfortivpn/archive/v1.15.0.tar.gz"
  sha256 "5279dbd3da779b818d201bbd9243cff9421a7e790fd2190438610a03c88641f8"
  license "GPL-3.0-or-later"

  bottle do
    sha256 "c7809f586984e5a763db26ca3b783a5a4d3c39ada3a9a49b3578a5cfa05483ad" => :big_sur
    sha256 "c6cdf1ae2c7f2c01bf5efe3c958c31bc7a5853e0950c2dedf661950961079373" => :arm64_big_sur
    sha256 "e39f7fb2a5e3ab15632ae1568b4c969dec71fab19b99e50da5b061d7599c8906" => :catalina
    sha256 "bc45f74d11de64c9db45bed0c9c2b7b8b0c5b9467c6d4354ba17fa89467c0a2e" => :mojave
    sha256 "58d6f22f8d8f3c3e81abe98ea282d8f0b86139a54c2367a6d91d7c7a7862ceee" => :high_sierra
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
