class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  url "https://downloads.powerdns.com/releases/pdns-recursor-4.0.1.tar.bz2"
  sha256 "472db541307c8ca83a846d260ecfc854fd8e879c1bb2ce5683a8df5d21e860b0"

  bottle do
    cellar :any_skip_relocation
    sha256 "90319425e9cf1c1bf5db4a1c62c48d98f88dc57f321cbfdb4be48dc91330e93f" => :el_capitan
    sha256 "68e80d6dd093d9ab1c986d9f68c97dfe9d8b46b228c4b27d64ce4bcd47105250" => :yosemite
    sha256 "afc4630468ea74d4a7aec183f5f5f3c4872b3bcca1aac7a58c9a579aa7d0cbcc" => :mavericks
    sha256 "a9faf9edf0e71de5e9ec9fa70d27811f353a8451b41746208fbdc0d592aa5910" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "openssl"
  depends_on "lua"

  needs :cxx11

  fails_with :clang do
    build 600
    cause "incomplete C++11 support"
  end

  def install
    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}/powerdns
      --disable-silent-rules
      --with-boost=#{Formula["boost"].opt_prefix}
      --with-openssl=#{Formula["openssl"].opt_prefix}
      --with-lua
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    output = shell_output("#{sbin}/pdns_recursor --version 2>&1")
    assert_match "PowerDNS Recursor #{version}", output
  end
end
