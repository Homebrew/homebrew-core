class Openfortivpn < Formula
  desc "Open Fortinet client for PPP+SSL VPN tunnel services"
  homepage "https://github.com/adrienverge/openfortivpn"
  url "https://github.com/adrienverge/openfortivpn/archive/v1.19.0.tar.gz"
  sha256 "9e244c3b63176269ce433349e67f8fd6e532f7c8d515f4c97558911a449152c3"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_monterey: "021e9dc0aa18a3e61131c84b499107e561c7bfeaea28a76d02bf85e16ef849e9"
    sha256 arm64_big_sur:  "292f0b690765ba68799685e3e98bfd46a09aef55e8ba864a7595eb8db8e7208a"
    sha256 monterey:       "277a223c0fa94e019224e96ada4760d7d43a9b122cddf6d6cc938185591e796a"
    sha256 big_sur:        "3185a7176408ac4e1307b0402501ae786a2d4c54315e7c7159ff8cb153a4c03f"
    sha256 catalina:       "2f49a2998e0779985fe6d204265110c917125e57bf35343ba77c2135b19b6d08"
    sha256 x86_64_linux:   "031e6c834bff0df1ac5525d4f0e9113d50a50ef5f3b51728ed707ad8f78819d4"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@3"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}/openfortivpn"
    system "make", "install"
  end

  plist_options startup: true
  service do
    run [opt_bin/"openfortivpn", "-c", etc/"openfortivpn/openfortivpn/config"]
    keep_alive true
    log_path var/"log/openfortivpn.log"
    error_log_path var/"log/openfortivpn.log"
  end

  test do
    system bin/"openfortivpn", "--version"
  end
end
