class Openconnect < Formula
  desc "Open client for Cisco AnyConnect VPN"
  homepage "https://www.infradead.org/openconnect/"
  url "ftp://ftp.infradead.org/pub/openconnect/openconnect-8.10.tar.gz"
  mirror "https://fossies.org/linux/privat/openconnect-8.10.tar.gz"
  sha256 "30e64c6eca4be47bbf1d61f53dc003c6621213738d4ea7a35e5cf1ac2de9bab1"
  license "LGPL-2.1-only"
  revision 1

  livecheck do
    url "https://www.infradead.org/openconnect/download.html"
    regex(/href=.*?openconnect[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "edf9df9e2ed7e9cfcfbf6437f43c6fd5e7b09e3e4519a2ef1ef06191227e820e"
    sha256 arm64_big_sur:  "a3978805ab233f6ba6c5fc36f8adc6943ea123ca995b5e85b0aad78276e163cd"
    sha256 monterey:       "1b88e9c97774ff7fbd214a9a780c3fa884b5351d9170808d10813c6b28570996"
    sha256 big_sur:        "ce70a3465eef3aeb351a7c57ccfefa5df0776828e3eddcfc098f552c01a4302d"
    sha256 catalina:       "c807c5ac80da0bc34ac1cc65da8ac39d397ec20358c44431e447d1fdb938c6ff"
    sha256 x86_64_linux:   "2fc57d20d9d07e71f2c7208cfe55ace9183cd5f3b1883ad5910ec2e4710de0b1"
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
    url "https://gitlab.com/openconnect/vpnc-scripts/raw/cda38498bee5e21cb786f2c9e78ecab251c997c3/vpnc-script"
    sha256 "f17be5483ee048973af5869ced7b080f824aff013bb6e7a02e293d5cd9dff3b8"
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
