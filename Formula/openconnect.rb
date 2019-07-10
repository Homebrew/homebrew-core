class Openconnect < Formula
  desc "Open client for Cisco AnyConnect VPN"
  homepage "https://www.infradead.org/openconnect/"
  url "ftp://ftp.infradead.org/pub/openconnect/openconnect-8.03.tar.gz"
  mirror "https://fossies.org/linux/privat/openconnect-8.03.tar.gz"
  sha256 "908cff9b1ce266b6bb7f969a7f62723543ab94719ba3c95a150fe3894cbc9ef2"

  bottle do
    sha256 "81adb07bc57b21684c538aca1c9c7c747ad0512f0ca422b61b0d527bd86945e6" => :mojave
    sha256 "e83422d30ea3df9b7c967ae937a2bbc67d5fd7dceced990626a01121276f8dcc" => :high_sierra
    sha256 "b00cc6e2c7db877e0244d71c1182cbd00859fd5cb6ed669ede57ad91d930ffe7" => :sierra
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
