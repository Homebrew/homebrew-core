class Openfortivpn < Formula
  desc "Open Fortinet client for PPP+TLS VPN tunnel services"
  homepage "https://github.com/adrienverge/openfortivpn"
  url "https://github.com/adrienverge/openfortivpn/archive/refs/tags/v1.24.2.tar.gz"
  sha256 "9e773c773bdb1d44b2d54215e43573adcca1685ed0e63e58177bf52e16cbf7e5"
  license "GPL-3.0-or-later" => { with: "cryptsetup-OpenSSL-exception" }
  head "https://github.com/adrienverge/openfortivpn.git", branch: "master"

  bottle do
    manifest_sha256 "60d74e81333af6e120954e933b688e83b8a01a402f9c11134168d87f40ca1e75"
    sha256 arm64_golden_gate: "3cab91e96399fd3ba82cea0852466fe3b5c695b72060bea2bc751fa5223d2c4f"
    sha256 arm64_tahoe:       "60b17eea5b2760b6d9f57b1b75c9ab3320a55b6077569bf7a8477c8c5d3ed9a3"
    sha256 arm64_sequoia:     "3a2457e27663ed18555a0a59e191dd49051140ccbebec767f28a1ae94b9e619a"
    sha256 arm64_linux:       "3aef1f080c217234fa9d532f2e4905ea94cbb663eff1e11d67bdf11143a96985"
    sha256 x86_64_linux:      "4381ddd3e996405a7db8c4ee0fe3177275e9dd09579e4bf3b481f63dd3002b00"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@4"

  # awaiting formula creation
  # uses_from_macos "pppd"

  deny_network_access!

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
