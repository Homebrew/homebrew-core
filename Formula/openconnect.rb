class Openconnect < Formula
  desc "Open client for Cisco AnyConnect VPN"
  homepage "https://www.infradead.org/openconnect/"
  url "ftp://ftp.infradead.org/pub/openconnect/openconnect-8.10.tar.gz"
  mirror "https://fossies.org/linux/privat/openconnect-8.10.tar.gz"
  sha256 "30e64c6eca4be47bbf1d61f53dc003c6621213738d4ea7a35e5cf1ac2de9bab1"
  license "LGPL-2.1-only"

  livecheck do
    url "https://www.infradead.org/openconnect/download.html"
    regex(/href=.*?openconnect[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "56300f1c7b529fefee693317fdef890e6a70fb64b777be7a77a0ce732752a7d1"
    sha256 arm64_big_sur:  "94132025cfdc325c792b5eed39e3afe8f86bf4512e06379d8374aabd72364115"
    sha256 monterey:       "261ce1be36763ba10808f8c65723d6525b85da26899f0fc979fc52ab1c4f0809"
    sha256 big_sur:        "9755c4ea66ed9c8aa1f1ee966c932ec2be37849887636d8f65a920f20c16ec55"
    sha256 catalina:       "b4144970e695adc8f049319408cd431c96eb2ca4714feb903e0f01f3926dfd1f"
    sha256 mojave:         "5f4d9cb8a0a39983205bad4e1e6d7a2ae586f0725571fa83eac6421b8d6f4b9a"
    sha256 high_sierra:    "4d306766b4a334c7dcc8497b0684005c9011cd8913131b25bae2f56f3b3217d1"
    sha256 x86_64_linux:   "405f966a059349a5ad2fdc8b3ae96bada1e34d466838d90611f284cb46909d0c"
  end

  head do
    url "git://git.infradead.org/users/dwmw2/openconnect.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "stoken"

  resource "vpnc-script" do
    url "https://git.infradead.org/users/dwmw2/vpnc-scripts.git/blob_plain/c0122e891f7e033f35f047dad963702199d5cb9e:/vpnc-script"
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
