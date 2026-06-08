class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/powerdns-recursor"
  url "https://downloads.powerdns.com/releases/pdns-recursor-5.4.2.tar.xz"
  sha256 "a4cea2981dc78b394999fffe28eff9096e214d5e4229c5c2ec07bff3efd02d59"
  license "GPL-2.0-only" # with OpenSSL Exception (non-SPDX)

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "f6f9c449b12400c18256e98ff071fa660da243cc5ed14a1e5764406d8e9dc775"
    sha256 arm64_sequoia: "85112cd5df40f2ed495f834520178e4d359982ace97f35ab866b15c04dac6ba8"
    sha256 arm64_sonoma:  "95fa8757e5ee09f94da723af8bf369d825e88d77759fa9fa877d0f876ca9112a"
    sha256 sonoma:        "9a496db609c47d2160e4b9802f7e9770f1c5804deb65b06c1382a5f5a0f374ce"
    sha256 arm64_linux:   "0deffd56b912e0233eed1dd6fa7d09f861d72c18a886e3d330b60a71e7487c41"
    sha256 x86_64_linux:  "38f12d314028c935e1f1cf9042d0194db53f571e2dc58e2dbbcd460cc5ae0f89"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "boost"
  depends_on "lua"
  depends_on "openssl@3"

  uses_from_macos "python" => :build
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
    args = %W[
      --sysconfdir=#{etc}/powerdns
      --disable-silent-rules
      --with-boost=#{Formula["boost"].opt_prefix}
      --with-libcrypto=#{Formula["openssl@3"].opt_prefix}
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
