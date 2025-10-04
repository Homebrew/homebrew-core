class Openfortivpn < Formula
  desc "Open Fortinet client for PPP+TLS VPN tunnel services"
  homepage "https://github.com/adrienverge/openfortivpn"
  url "https://github.com/adrienverge/openfortivpn/archive/refs/tags/v1.23.1.tar.gz"
  sha256 "ecacfc7f18d87f4ff503198177e51a83316b59b4646f31caa8140fdbfaa40389"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }
  head "https://github.com/adrienverge/openfortivpn.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "683a43f9d6a35ecce0989ac17cb45c1d96fd1d227410fa3c1d99d9a99e210001"
    sha256 arm64_sequoia: "1ae366135c78e77a61e53bc6c8c05b5517f715f64b580ee20c7f380e4772b483"
    sha256 arm64_sonoma:  "28994d4959537dbfe5702aed1d16e7c09096e6957b5640f3b89da6669deecefe"
    sha256 arm64_ventura: "39bd9a1bd6b7a26eb5a10a4bbd2a3ed9d50b72aa1b80d64fffe95430734a36d8"
    sha256 sonoma:        "638d300356138d5dfb66500e01e71b2e07d7fdfbf6151cf4b3d389db04744c33"
    sha256 ventura:       "b3c8630701ae6d1ee308c0e4e72885e296d59bd83fec77eb21d7046e3c6a50fe"
    sha256 arm64_linux:   "9803841bf3a552d2220d7a213b6337cbae3cdb6759632105aa5c98bedaeeee51"
    sha256 x86_64_linux:  "9182218ccc8af0571af8445f8458843d61056e6186407293707c2d27f2e88903"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  # awaiting formula creation
  # uses_from_macos "pppd"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-silent-rules",
                          "--enable-legacy-pppd", # only for pppd < 2.5.0
                          "--sysconfdir=#{etc}/openfortivpn",
                          *std_configure_args
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
