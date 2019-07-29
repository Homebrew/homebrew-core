class Openconnect < Formula
  desc "Open client for Cisco AnyConnect VPN"
  homepage "https://www.infradead.org/openconnect/"
  url "ftp://ftp.infradead.org/pub/openconnect/openconnect-8.03.tar.gz"
  mirror "https://fossies.org/linux/privat/openconnect-8.03.tar.gz"
  sha256 "908cff9b1ce266b6bb7f969a7f62723543ab94719ba3c95a150fe3894cbc9ef2"

  bottle do
    sha256 "a9c47c6f30be70320aa1d86ba6c449cd5d60d5d6c2335ceb3c14ca35b064cc69" => :mojave
    sha256 "70b3fc3ec62a6b91567325fcb0c14906e1cd739de8334202bf9765dab96537be" => :high_sierra
    sha256 "5cd4f699bddb17caeec819f0415a6a378046fcdd8343178f4aa8324ee541b173" => :sierra
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
