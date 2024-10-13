class Openfortivpn < Formula
  desc "Open Fortinet client for PPP+TLS VPN tunnel services"
  homepage "https://github.com/adrienverge/openfortivpn"
  url "https://github.com/adrienverge/openfortivpn/archive/refs/tags/v1.22.1.tar.gz"
  sha256 "9aaaae2229f01b35bf79dcc9e1c0a4363cec75084a30fd46df58c20d52bff809"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }
  head "https://github.com/adrienverge/openfortivpn.git", branch: "master"

  bottle do
    sha256 arm64_sequoia:  "57822a57fca8d720b5848885d49b39eb4f6ea35da9e9003bee8c122f83c58f7e"
    sha256 arm64_sonoma:   "946734a0e699c191de0514da876e803c048b205aae824c4f8420ab50bbdb37fa"
    sha256 arm64_ventura:  "580097ee6f08798f95b62c4598f1ed966ed4c85aec9a2c31a602c1ba2a0e59fa"
    sha256 arm64_monterey: "5653d24c9352334c49c33f19ff5514bca38b5cc4d0e94ebbd68da4b2675730de"
    sha256 sonoma:         "de8c7bd44f6f7c79c48b340cc1884b6f97c04ca96555a2aa84d96c25c327126d"
    sha256 ventura:        "47ff2f44fdeffc326ae23aa344b9a5d8b82fb9b64365bf3d66bcd07b823e2387"
    sha256 monterey:       "3ce32945254b9a2f25fe4e0534564b93e545ed8d54271204f478537c9d904d42"
    sha256 x86_64_linux:   "7a059b81db6de8273b0b44e6d53686f58e76264e7c7fc031823479a6fa07c551"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@3"

  # awaiting formula creation
  # uses_from_macos "pppd"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-legacy-pppd", # only for pppd < 2.5.0
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
