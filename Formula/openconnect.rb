class Openconnect < Formula
  desc "Open client for Cisco AnyConnect VPN"
  homepage "https://www.infradead.org/openconnect/"
  url "ftp://ftp.infradead.org/pub/openconnect/openconnect-8.01.tar.gz"
  mirror "https://fossies.org/linux/privat/openconnect-8.01.tar.gz"
  sha256 "48868a4f99c81a7474d87fbabb41b8eaa7d32b54771c9f23a7aea72d9cd626fd"

  bottle do
    sha256 "e9a11f88f2c226e6e5f9b2197e25f4f13b8c1dbdb237136de4cf1ea97cd19868" => :mojave
    sha256 "834d8b3e6558cef61d83172d148d22d4f0d450768ed4e722d8101ac69ff5b5f8" => :high_sierra
    sha256 "e2beb9d5cb97c346f1046f810354c06a4c39d08e958e9306f53fe1f7f6e9c894" => :sierra
  end

  head do
    url "git://git.infradead.org/users/dwmw2/openconnect.git", :shallow => false
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnutls"

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
    assert_match "Open client for multiple VPN protocols", pipe_output("#{bin}/openconnect 2>&1")
  end
end
