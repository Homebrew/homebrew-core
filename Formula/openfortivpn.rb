class Openfortivpn < Formula
  desc "Open Fortinet client for PPP+SSL VPN tunnel services"
  homepage "https://github.com/adrienverge/openfortivpn"
  url "https://github.com/adrienverge/openfortivpn/archive/v1.20.1.tar.gz"
  sha256 "2d40ef67e188ebaa536e115263980c097e37c80afc4c2a1fd8cfa576aa616d5e"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }

  bottle do
    sha256 arm64_ventura:  "cf3085228d1c1d791e69d60fc848b4758ff224359f3dedd46d7aa8d149fa1936"
    sha256 arm64_monterey: "2f65a3ce47bfa55079ece31bf270b4111ddd9ac81ac742a8243afe1c6600e932"
    sha256 arm64_big_sur:  "7e130cbe9a544dbd3d447d455399ef8cef88d31b0e81e8a8e0713b2a469f67a2"
    sha256 ventura:        "c06e9f31eda964a6622822a8a1b0178c73c9eb38ceae9dbefdf6994558a1c454"
    sha256 monterey:       "ff5c82ec39545a45ca3676cca127c699e438e0eb2d0972cf98bddab8994a9c6e"
    sha256 big_sur:        "36df758b6d887467cd0e90f704d0b603f5486ac6f5375d845bb391cdbb9afdfb"
    sha256 catalina:       "4a09b2f6e762b7eac8e5e8ce0ca2997e1764439c3af6e5b54aa019c532c45e2b"
    sha256 x86_64_linux:   "66bd0b3ebcaea501bda4aca5664ec71503b6930c24fdc2300f0ab96094438f7b"
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

  service do
    run [opt_bin/"openfortivpn", "-c", etc/"openfortivpn/openfortivpn/config"]
    keep_alive true
    require_root true
    log_path var/"log/openfortivpn.log"
    error_log_path var/"log/openfortivpn.log"
  end

  test do
    system bin/"openfortivpn", "--version"
  end
end
