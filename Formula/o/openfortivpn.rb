class Openfortivpn < Formula
  desc "Open Fortinet client for PPP+TLS VPN tunnel services"
  homepage "https://github.com/adrienverge/openfortivpn"
  url "https://github.com/adrienverge/openfortivpn/archive/refs/tags/v1.24.1.tar.gz"
  sha256 "c40d33acd97b89c2e943bfd839c19b69e5a7a5997052e2fc9a595602745c0465"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }
  revision 1
  head "https://github.com/adrienverge/openfortivpn.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "65d370bb770879309455473ac8e03569ab5ddd2a84618be63ccdecd8348e259c"
    sha256 arm64_sequoia: "00c49ac2a42509360a6dcac6ce039702872ad72b6ed0e2257663f7ed588a83d0"
    sha256 arm64_sonoma:  "2714c163f798702d0cd1f635d2e424f5679890260bc6187893bca3fb4d291872"
    sha256 sonoma:        "db7037d4ae45940d7c7aeac8987f0c0346d2e31f6dd2acbfc99aca2fad16274b"
    sha256 arm64_linux:   "9e03b7e692f3c88109b5d3b0e69a156f523829413a1da57fe89efdf8c744d22c"
    sha256 x86_64_linux:  "71e318785c859da9d6de4d9cc0c4b4f96cd92af2e1cb101d8b6a28488bcd06e9"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@4"

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
