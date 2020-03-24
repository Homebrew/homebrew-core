class Openfortivpn < Formula
  desc "Open Fortinet client for PPP+SSL VPN tunnel services"
  homepage "https://github.com/adrienverge/openfortivpn"
  url "https://github.com/adrienverge/openfortivpn/archive/v1.13.2.tar.gz"
  sha256 "998fb2b071cdfe3255c2f953cafc6e1496778f9a71dd5aa560b924a44636df87"

  bottle do
    sha256 "d09a71f63744c214c2ebac8aff8126a72de33ef770f329674239844f84549208" => :catalina
    sha256 "775d46fd3f2e309e8659b3967835895b0faf176a9f7ff1f5e556a5de85d1cabb" => :mojave
    sha256 "6f4841b1e3ac036deafd19bec83ac24fd800fc95400297c2aa7b3398ca742bf4" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
  test do
    system bin/"openfortivpn", "--version"
  end
end
