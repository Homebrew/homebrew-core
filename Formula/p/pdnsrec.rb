class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/powerdns-recursor"
  url "https://downloads.powerdns.com/releases/pdns-recursor-5.4.5.tar.xz"
  sha256 "13105768d9490067596f263d7d348bcc0c6798574c7d991cc40952f18b9dac11"
  license "GPL-2.0-only" # with OpenSSL Exception (non-SPDX)
  revision 1

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "a5bf9567a112023359c4165145562560502d9dee934c41b13afb55f900a85175"
    sha256 arm64_sequoia: "2c03657faae5a9e2aca1ffeefe930303d0a942afa62d5b5197232e9e94e51314"
    sha256 arm64_sonoma:  "cf50d9a2463eccf5211872490e62af4286a98db986b35dbdf12d6ba2aa9c8265"
    sha256 sonoma:        "5a065581c40cc757bb7a96fc68a57b313860399b15344ccf8cd68077d1139d7a"
    sha256 arm64_linux:   "91a86ae5b28936cad1f4e9c08c3d2076c7604bee3c3b09b02b5b1afb51fe74d9"
    sha256 x86_64_linux:  "fa807c80fa3e260889a4bb45160bb718f733837a201921648651ef075feef7ae"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "boost"
  depends_on "lua"
  depends_on "openssl@3"

  uses_from_macos "python" => :build
  uses_from_macos "curl"

  def install
    args = %W[
      --sysconfdir=#{etc}/powerdns
      --disable-silent-rules
      --with-boost=#{formula_opt_prefix("boost")}
      --with-libcrypto=#{formula_opt_prefix("openssl@3")}
      --with-lua
      --without-net-snmp
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{sbin}/pdns_recursor --version 2>&1")
    assert_match "PowerDNS Recursor #{version}", output
  end
end
