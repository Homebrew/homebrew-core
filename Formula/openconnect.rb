class Openconnect < Formula
  desc "Open client for Cisco AnyConnect VPN"
  homepage "https://www.infradead.org/openconnect/"
  url "ftp://ftp.infradead.org/pub/openconnect/openconnect-8.04.tar.gz"
  mirror "https://fossies.org/linux/privat/openconnect-8.04.tar.gz"
  sha256 "98979c6e3f78b294dc663e3fd75d5c9e9d779f247be9d4e3ab84b5e90565f81f"

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
