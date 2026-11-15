class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/powerdns-recursor"
  url "https://downloads.powerdns.com/releases/pdns-recursor-5.4.9.tar.xz"
  sha256 "66feabd86e32d5fb38e50664e79942f64badeb7232d7dec5bc3da268b4e381ff"
  license "GPL-2.0-only" # with OpenSSL Exception (non-SPDX)

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "7a0dfd23a7eb10fa4d8f952381752c580063ef2acacc2877e104c89e8630683b"
    sha256 arm64_tahoe:       "269a84f69b6af7ab3198e3f358ea987e14330177a6cb64b33e48644ee9b97dfc"
    sha256 arm64_sequoia:     "e31f4e9ecaa98b11b5b55ef255d208e4ee844b1b1aef0dd2764609e7139aa25c"
    sha256 arm64_linux:       "e5a4617b5223b72e27b0bf27f2c494e37db954d10267a546d5898d11985752b1"
    sha256 x86_64_linux:      "523c63455ec90f0749a3cd1e1394454c31c7c74c1630943025bf2fd8b35ae563"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "boost"
  depends_on "lua"
  depends_on "openssl@4"

  uses_from_macos "python" => :build
  uses_from_macos "curl"

  deny_network_access!

  def openssl = deps.map(&:name).find { |d| d.match?(/^openssl(@\d+(\.\d+)*)?$/) }

  def fetch
    cd "rec-rust-lib/rust" do
      system "cargo", "fetch", *std_cargo_fetch_args
    end
  end

  def install
    args = %W[
      --sysconfdir=#{etc}/powerdns
      --disable-silent-rules
      --with-boost=#{formula_opt_prefix("boost")}
      --with-libcrypto=#{formula_opt_prefix(openssl)}
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
