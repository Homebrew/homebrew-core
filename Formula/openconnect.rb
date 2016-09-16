class Openconnect < Formula
  desc "Open client for Cisco AnyConnect VPN"
  homepage "http://www.infradead.org/openconnect.html"
  url "ftp://ftp.infradead.org/pub/openconnect/openconnect-7.07.tar.gz"
  sha256 "f3ecfcd487dcd916748db38b4138c1e72c86347d6328b11dfe1d0af2821b8366"

  bottle do
    sha256 "cbe08c848c2965016b4a01113781f033498e529a3ddbf86ca9c4528f34838cf9" => :sierra
    sha256 "5e828d31f978b4f8cff97b058ec7edbe1f949dfe9f92abf906c74b16dc26e3b5" => :el_capitan
    sha256 "4ddea4db39118b9600aec149888fba1fe1888d82f0ddc893bb69d3ed73b1fd46" => :yosemite
    sha256 "0ccb117a630209f21d7479b06043c2ba32d006055213ac936fc41869974d6b25" => :mavericks
  end

  head do
    url "git://git.infradead.org/users/dwmw2/openconnect.git", :shallow => false
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # No longer compiles against OpenSSL 1.0.2 - It chooses the system OpenSSL instead.
  # https://lists.infradead.org/pipermail/openconnect-devel/2015-February/002757.html

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "oath-toolkit" => :optional
  depends_on "stoken" => :optional

  resource "vpnc-script" do
    url "http://git.infradead.org/users/dwmw2/vpnc-scripts.git/blob_plain/a64e23b1b6602095f73c4ff7fdb34cccf7149fd5:/vpnc-script"
    sha256 "cc30b74788ca76928f23cc7bc6532425df8ea3701ace1454d38174ca87d4b9c5"
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
