class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/powerdns-recursor"
  url "https://downloads.powerdns.com/releases/pdns-recursor-5.2.0.tar.bz2"
  sha256 "69e390b40a2228964a1d4db85a067065fd4513d26318c858d24b4972f6b73010"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }
  revision 1

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "711514c2e6f8e074667ccb9b87c06891bd4ab218f46c167cffdc422ff26d06da"
    sha256 arm64_sonoma:  "07680d46ee62dc1cd1ba9dd3b679b0f83f93044cd5e9e842e4effbfd7e455388"
    sha256 arm64_ventura: "176a3f47e3839dee421c9d9c13dbb7982c55d8bfef5cf320071cf4fc93a2f0e2"
    sha256 sonoma:        "2ded0a3853fcacbbe5623d74c3804b619562c6c76c06546eb6fecf9f8c9fe91a"
    sha256 ventura:       "f543d0d328587c583cc419d837f3e3a9188db6606c4ec38eb0518e9e3fffc6e3"
    sha256 arm64_linux:   "01bf579837cd9a15c472c3c07ded7d253bd36bdbc3e7d6c457cc8c8708f67724"
    sha256 x86_64_linux:  "b4e16e947cdb9388e8fe172d55d42f8cff0cadc0ce388ff47cfc0cb1881dfd5a"
  end

  depends_on "pkgconf" => :build
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
