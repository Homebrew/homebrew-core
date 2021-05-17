class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  url "https://downloads.powerdns.com/releases/pdns-recursor-4.5.1.tar.bz2"
  sha256 "3721a1d0e438a683735f518db1e91da6ace1b90fbfdb9c588adabdf164114e79"
  license "GPL-2.0-only"

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "48090a25f0c900d4f194ab2e12b8cff257c2c28ee48ba1a0be3cfef6613d5488"
    sha256 big_sur:       "5a70aeb0c0d0fd57d3529744b7c5a0bdeaecfb1897dd07cc0ba83a6fb883a089"
    sha256 catalina:      "b1653e702eee140a2bd6bd0ff463a9fec7b05fc998d87c4c5bf76b46b4e8a0bb"
    sha256 mojave:        "8656a83c7405cfeec550aae38a45ec31fd5b82ce3794394bc403da4c6cd7acad"
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "lua"
  depends_on "openssl@1.1"

  on_macos do
    depends_on "llvm" => :build if MacOS.version <= :mojave
  end

  fails_with :clang do
    build 1100
    cause <<-EOS
      Undefined symbols for architecture x86_64:
        "MOADNSParser::init(bool, std::__1::basic_string_view<char, std::__1::char_traits<char> > const&)"
    EOS
  end

  def install
    ENV.cxx11
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib
    on_macos do
      ENV.llvm_clang if MacOS.version <= :mojave
    end

    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}/powerdns
      --disable-silent-rules
      --with-boost=#{Formula["boost"].opt_prefix}
      --with-libcrypto=#{Formula["openssl@1.1"].opt_prefix}
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
