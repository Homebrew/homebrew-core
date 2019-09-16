class Openconnect < Formula
  desc "Open client for Cisco AnyConnect VPN"
  homepage "https://www.infradead.org/openconnect/"
  url "ftp://ftp.infradead.org/pub/openconnect/openconnect-8.05.tar.gz"
  mirror "https://fossies.org/linux/privat/openconnect-8.05.tar.gz"
  sha256 "335c2952d0cb36822acb112eaaf5e3b4acffc6874985fb614fec0b76c4c12992"

  bottle do
    sha256 "440a031dc0467ba3928fc2ab380e50c0c8b64042c109885856061f03f8bf5d86" => :mojave
    sha256 "3a4cf289c1c8c57d5a83b2993791b1a64a5af25b655ba15ff70b9a8ddd9b8bbc" => :high_sierra
    sha256 "ffd8c90ee9cc4d69f7f6efbeb57727b2e87c910b9920786ae9055d2177e8600c" => :sierra
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
  depends_on "stoken"

  resource "vpnc-script" do
    url "http://git.infradead.org/users/dwmw2/vpnc-scripts.git/blob_plain/c84fb8e5a523a647a01a1229a9104db934e19f00:/vpnc-script"
    sha256 "20f05baf2857cb48073aca8b90d84ddc523f09b9700a5986a2f7e60e76917385"
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
