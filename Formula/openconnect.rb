class Openconnect < Formula
  desc "Open client for Cisco AnyConnect VPN"
  homepage "https://www.infradead.org/openconnect/"
  url "ftp://ftp.infradead.org/pub/openconnect/openconnect-8.08.tar.gz"
  mirror "https://fossies.org/linux/privat/openconnect-8.08.tar.gz"
  sha256 "b74b30ebabbd4801056e46c0373e71f3d41c75b805fcc7ee8fc586fe559379e8"

  bottle do
    sha256 "75337e3ef5910b8236bddb38c949bdcb0b8032716f24a67ae0f05c5a563b86ed" => :catalina
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
