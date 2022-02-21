class Openconnect < Formula
  desc "Open client for Cisco AnyConnect VPN"
  homepage "https://www.infradead.org/openconnect/"
  url "ftp://ftp.infradead.org/pub/openconnect/openconnect-8.20.tar.gz"
  mirror "https://fossies.org/linux/privat/openconnect-8.20.tar.gz"
  sha256 "c1452384c6f796baee45d4e919ae1bfc281d6c88862e1f646a2cc513fc44e58b"
  license "LGPL-2.1-only"

  livecheck do
    url "https://www.infradead.org/openconnect/download.html"
    regex(/href=.*?openconnect[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "4e08fdd7f2b814a88445ed088151cd056022521b15c37fc40b018440d282113d"
    sha256 arm64_big_sur:  "414f228ce4ac24b4c0283c6ada6ecfff43d320155baccdb2912490949e802575"
    sha256 monterey:       "273c02a215e4f2c73316367a7e8a71432d73718ae7bbdffbfded58f178f09c3e"
    sha256 big_sur:        "738d8d35421582bbf406f51db429e211012b79290a567341340562f776389e2e"
    sha256 catalina:       "4ca4203a7464c7735821a25ddd40816e374167e5ac8cbbae9c16fa31a09f5228"
    sha256 x86_64_linux:   "9a9bcf3569d6680d3c5d976fc1b77b2400ada7bdd8fc87a1905e338940403a8a"
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
