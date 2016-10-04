class Openconnect < Formula
  desc "Open client for Cisco AnyConnect VPN"
  homepage "http://www.infradead.org/openconnect.html"
  url "ftp://ftp.infradead.org/pub/openconnect/openconnect-7.07.tar.gz"
  sha256 "f3ecfcd487dcd916748db38b4138c1e72c86347d6328b11dfe1d0af2821b8366"
  revision 1

  bottle do
    sha256 "f53757bf0e0347afd992613a68ed3d8a96e5c0e4fc71a034774cce6a9d5e7ed9" => :sierra
    sha256 "5e2c2b5542d489fac52294c16aecc31f7ce4b0479a9e7e3adbe4406ab60891f1" => :el_capitan
    sha256 "41ea64f23f6eb4b4cbf06d52172938c6e80e7ff62cad4fc619db8e808b27aa78" => :yosemite
  end

  head do
    url "git://git.infradead.org/users/dwmw2/openconnect.git", :shallow => false
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-gnutls", "Use GnuTLS instead of OpenSSL"

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "openssl" if build.without? "gnutls"
  depends_on "gnutls" => :optional
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
