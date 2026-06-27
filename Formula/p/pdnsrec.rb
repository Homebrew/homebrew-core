class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/powerdns-recursor"
  url "https://downloads.powerdns.com/releases/pdns-recursor-5.4.3.tar.xz"
  sha256 "a292029c543ac4538ca57628b8142c9edca9b283a3a80cb393ed947e0584f00f"
  license "GPL-2.0-only" # with OpenSSL Exception (non-SPDX)

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "ebf81d96453e887f5d1929b29cea8b773534995d1c4710d5a5dff230dffee8e3"
    sha256 arm64_sequoia: "ca4601fb94fc80c35dee23b29a1e53733ad1b88940dd48d26ba8b338afdf1769"
    sha256 arm64_sonoma:  "d4083001f063a96e442d3990673811741988bacbd1ceb7dbfe9e610b8c1d662a"
    sha256 sonoma:        "003c9c9872401cadd74618e7cdeb83a9a094b3c2cf0c63a69080e0594ee80d4d"
    sha256 arm64_linux:   "14575f6cf1fb46ad741f0bd74caa19eb7344f19ad22b1300020ee75e26fab997"
    sha256 x86_64_linux:  "1232b8267c159522191b16ea9a22a9b506b3096d7c9aef345368eb68488e0893"
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
