class Openconnect < Formula
  desc "Open client for Cisco AnyConnect VPN"
  homepage "https://www.infradead.org/openconnect/"
  url "http://ftp.infradead.org/pub/openconnect/openconnect-7.08.tar.gz"
  mirror "https://fossies.org/linux/privat/openconnect-7.08.tar.gz"
  sha256 "1c44ec1f37a6a025d1ca726b9555649417f1d31a46f747922b84099ace628a03"
  revision 1

  bottle do
    sha256 "81def078c335023993b56eb6879bbac860675069d23f6e75fd85e33276e439b2" => :mojave
    sha256 "ebc3bc520522b80f49ad28fb9055242a93f4e9ee1abf49a8be9858c4f2c13b92" => :high_sierra
    sha256 "82f6f4b72fba93ee972a8455ebd6f9d9dfb607cd4bdd06c4b0bf068c5dbc4547" => :sierra
    sha256 "41230a870a365a76eebd77a6a2255aa4e8f93eedc56c42546cd493967221f7c2" => :el_capitan
    sha256 "207b75663d9f34b99a0cb2f7c4b7eccd665a98f88b7e9d736928dd4b65b658ca" => :yosemite
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
