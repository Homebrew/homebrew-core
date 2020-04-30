class Openconnect < Formula
  desc "Open client for Cisco AnyConnect VPN"
  homepage "https://www.infradead.org/openconnect/"
  url "ftp://ftp.infradead.org/pub/openconnect/openconnect-8.09.tar.gz"
  mirror "https://fossies.org/linux/privat/openconnect-8.09.tar.gz"
  sha256 "f39802be4c3a099b211ee4cc3318b3a9a195075deab0b4c1c5880c69340ce9a6"

  bottle do
    sha256 "df6b2594f965aad9dc946202f5840f28d757246591fb2fda2b5de8931d740075" => :catalina
    sha256 "f6a7f879befdbc0948cb05a084b470fd689747e64aa8f4775871e6891c34b768" => :mojave
    sha256 "323feb1da71bb70aa92cb137d29244257bc35e52422a763514cdb69b1d686567" => :high_sierra
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
