class Openconnect < Formula
  desc "Open client for Cisco AnyConnect VPN"
  homepage "http://www.infradead.org/openconnect.html"
  url "ftp://ftp.infradead.org/pub/openconnect/openconnect-7.07.tar.gz"
  sha256 "f3ecfcd487dcd916748db38b4138c1e72c86347d6328b11dfe1d0af2821b8366"
  revision 2

  bottle do
    sha256 "266cc4b4de7651d73c938e5e4a4cf4b530f50cc6490e19f28bb7905c493b8e28" => :sierra
    sha256 "f3e140dd2008d6e4cfeec620de32d918a0ba2d0056c34595796297ab8f917c6a" => :el_capitan
    sha256 "e66d0122a808b3335f3731ba01086011dd1ff86368ded4ed1a09b9a5ec91c888" => :yosemite
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
