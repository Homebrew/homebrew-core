class Openfortivpn < Formula
  desc "Open Fortinet client for PPP+TLS VPN tunnel services"
  homepage "https://github.com/adrienverge/openfortivpn"
  url "https://github.com/adrienverge/openfortivpn/archive/refs/tags/v1.22.0.tar.gz"
  sha256 "473b31d643ecbd227f5cabd800a7bf75b44d262170957418edaa72d64df8fef4"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }

  bottle do
    sha256 arm64_sonoma:   "69f7f690f0dcc20d60212ef53671d267d52d6477d4a19f847c77c642492587b1"
    sha256 arm64_ventura:  "61a181a416a22818dfdb12b4a8d3c0dfe480b82e38ad7687df7ca40809d720ec"
    sha256 arm64_monterey: "a342408f9e6b934df3cc2a6501154cb41573098407df9860a8b86c19e8d3c54c"
    sha256 sonoma:         "c7e1b3aeabe3754ed6ab02bdf1d2e51249dd848ed28bb2a550191c496c376ebb"
    sha256 ventura:        "cbb5d9f690e36581f9296460345be4c3c0e0476ffe58e7b7127eddcc226e5d77"
    sha256 monterey:       "10abb07c88a10d88aa05e1614d9da8f3f529d181c2b81c604c4e1e0735f2a457"
    sha256 x86_64_linux:   "4b570590fbd21801ab5b7562b2d3266c3e2b96812d0f0fac7f9765fc61e767c7"
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
