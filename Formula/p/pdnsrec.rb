class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/powerdns-recursor"
  url "https://downloads.powerdns.com/releases/pdns-recursor-5.3.1.tar.xz"
  sha256 "a7b633d4b5da3b5f14d51a78e21e17f1334c828ce96fcccdd97cd7aaaf14cbd5"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "04573b19ac9ad286f82c0b4b8bef70861875a5d358e0739f15fb0a9863824a8d"
    sha256 arm64_sequoia: "b9d5877bd13b6599d8c5847b0c180b2f8a1f70c6366f73b25ca580de20e00ea4"
    sha256 arm64_sonoma:  "d1dcd99df6ca24a5d8ab276a9597afac6d4a549b92e1ebac028b64bb5db965bd"
    sha256 sonoma:        "ee8f61e0777b8571c0a7d5b90019222f3cbe44e67c9614acf08c641923307987"
    sha256 arm64_linux:   "83ea589a2b3213073cbec9be8ac7e520ecd0cb4eb8ff11105edb9a6e7d9b33d8"
    sha256 x86_64_linux:  "02f6812dc25888fa5fa098b10cb837798a28f1b205de97cc9cc3b1a1abdfb933"
  end

  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on "rust" => :build
  depends_on "boost"
  depends_on "lua"
  depends_on "openssl@3"

  uses_from_macos "curl"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with :clang do
    build 1100
    cause <<~EOS
      Undefined symbols for architecture x86_64:
        "MOADNSParser::init(bool, std::__1::basic_string_view<char, std::__1::char_traits<char> > const&)"
    EOS
  end

  def install
    ENV.cxx11
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}/powerdns
      --disable-silent-rules
      --with-boost=#{Formula["boost"].opt_prefix}
      --with-libcrypto=#{Formula["openssl@3"].opt_prefix}
      --with-lua
      --without-net-snmp
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    output = shell_output("#{sbin}/pdns_recursor --version 2>&1")
    assert_match "PowerDNS Recursor #{version}", output
  end
end
