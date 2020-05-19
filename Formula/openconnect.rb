class Openconnect < Formula
  desc "Open client for Cisco AnyConnect VPN"
  homepage "https://www.infradead.org/openconnect/"
  url "ftp://ftp.infradead.org/pub/openconnect/openconnect-8.10.tar.gz"
  mirror "https://fossies.org/linux/privat/openconnect-8.10.tar.gz"
  sha256 "30e64c6eca4be47bbf1d61f53dc003c6621213738d4ea7a35e5cf1ac2de9bab1"

  bottle do
    sha256 "18019d0a73c0e2346aeaf6818e10fd6ade838d1a47db244c81811768ea0e6299" => :catalina
    sha256 "f0aab6ec1ae76b556c4d0248c62d6d481bb574fb5e2c464afb00981005e10015" => :mojave
    sha256 "41b32aa991b9c3eda683aa7b90342ce51f3cbfaab8fe515d78391939d6d8c04b" => :high_sierra
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
    url "http://git.infradead.org/users/dwmw2/vpnc-scripts.git/blob_plain/c0122e891f7e033f35f047dad963702199d5cb9e:/vpnc-script"
    sha256 "3ddd9d6b46e92d76e6e26d89447e3a82d797ecda125d31792f14c203742dea0f"
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
    assert_match "POST https://localhost/", pipe_output("#{bin}/openconnect localhost 2>&1")
  end
end
