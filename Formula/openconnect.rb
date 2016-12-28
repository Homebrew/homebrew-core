class Openconnect < Formula
  desc "Open client for Cisco AnyConnect VPN"
  homepage "http://www.infradead.org/openconnect.html"
  url "ftp://ftp.infradead.org/pub/openconnect/openconnect-7.08.tar.gz"
  sha256 "1c44ec1f37a6a025d1ca726b9555649417f1d31a46f747922b84099ace628a03"
  revision 1

  bottle do
    sha256 "6ca71944ac9c1f0f8324cf3eb3b494dc3838036265b786f479003e41dd053e32" => :sierra
    sha256 "991d5e4ed400b1aa18d855a5ae29477980e6ae203567e72b29ab9880e5990bcf" => :el_capitan
    sha256 "ee57ea1532750340f0ef11fe765a4bef226a505557e944aab039668fb155ba2f" => :yosemite
  end

  head do
    url "git://git.infradead.org/users/dwmw2/openconnect.git", :shallow => false
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # Use of GnuTLS is currently preferred as this results in a complete feature
  # set, i.e. DTLS MTU detection.
  option "with-openssl", "Use OpenSSL instead of GnuTLS"

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnutls" if build.without? "openssl"
  depends_on "openssl" => :optional
  depends_on "oath-toolkit" => :optional
  depends_on "stoken" => :optional

  resource "vpnc-script" do
    url "http://git.infradead.org/users/dwmw2/vpnc-scripts.git/blob_plain/6e04e0bbb66c0bf0ae055c0f4e58bea81dbb5c3c:/vpnc-script"
    sha256 "48b1673e1bfaacbfa4e766c41e15dd8458726cca8f3e07991d078d0d5b7c55e9"
  end

  def install
    etc.install resource("vpnc-script")
    chmod 0755, "#{etc}/vpnc-script"

    if build.head?
      ENV["LIBTOOLIZE"] = "glibtoolize"
      system "./autogen.sh"
    end

    args = %W[
      --prefix=#{prefix}
      --sbindir=#{bin}
      --localstatedir=#{var}
      --with-vpnc-script=#{etc}/vpnc-script
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match "AnyConnect VPN", pipe_output("#{bin}/openconnect 2>&1")
  end
end
