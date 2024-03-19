class Openfortivpn < Formula
  desc "Open Fortinet client for PPP+TLS VPN tunnel services"
  homepage "https://github.com/adrienverge/openfortivpn"
  url "https://github.com/adrienverge/openfortivpn/archive/refs/tags/v1.21.0.tar.gz"
  sha256 "e03242e1bc39de9d916674a4641830a004309c2fd52f0f23aae2f431924ec4ae"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "b4771b967f920be533a02071151acf1993b5e7a23c6721434f1634af5c2912b4"
    sha256 arm64_ventura:  "fdf89a41fb091d8e31335a60441a30add086c386f40f20b4036c7ce478d7848b"
    sha256 arm64_monterey: "a62558b10fe6d8ebe8e4b2248bafd87ccee2753af3a2d8b2c99f549ede7aa629"
    sha256 sonoma:         "b326509c4c5e9425dc862fe620bbba34bf3a9a8ce839acae73fd51ac024fa432"
    sha256 ventura:        "52fd759e336d2921d01a9b7facce76274af558daf92e6467c6512da7f0e9a2bc"
    sha256 monterey:       "4695372eeaeb1772b0ec63422932f2970c59487e70b2908c4406c6d2d3f73da5"
    sha256 x86_64_linux:   "8f08d3314a70126a2dc00807b2f1ed5782fe0b41945900a5cf22c527001e9dd6"
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
