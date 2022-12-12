class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  url "https://downloads.powerdns.com/releases/pdns-recursor-4.8.0.tar.bz2"
  sha256 "ccb9017a1a788e95e948e7b240ef8db53ae8a507b915f260188ef343f7f68bdc"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "33b9a6459851bdd4dcaefcfc502dc6036c4141af9709151b9cc9a93563d0a1f1"
    sha256 arm64_monterey: "db3ed7e89803589ff1367a1c2a37c7d893aaa2d223a9766584714eb2917916c0"
    sha256 arm64_big_sur:  "e30e5e8b23e6249ee8089670f16c3bd2afd3f0a9af7851d4b8815f87a720a72e"
    sha256 ventura:        "fda97eacdf011d62e1df556f0bf8dacbb868838b39280ae012a53a852e910487"
    sha256 monterey:       "bafcc08610b09459297933cd1a24e1b458a01bcbf65013a16d4800fd7d8a3a83"
    sha256 big_sur:        "f9cb1785e7203e5f24d77a0af7affe46af99cd4b53f90bde21db2300d5c55b61"
    sha256 catalina:       "093f84bd403d9af6f680392daa4a0245ba559e879e25d5eaa03acacdbf6d5a14"
    sha256 x86_64_linux:   "c153fb75cb1e50832f5b33d18462317a2cede63f75c58f370436d14f19fd68ae"
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "lua"
  depends_on "openssl@3"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with :clang do
    build 1100
    cause <<-EOS
      Undefined symbols for architecture x86_64:
        "MOADNSParser::init(bool, std::__1::basic_string_view<char, std::__1::char_traits<char> > const&)"
    EOS
  end

  fails_with gcc: "5"

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
