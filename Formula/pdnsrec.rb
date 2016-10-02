class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  url "https://downloads.powerdns.com/releases/pdns-recursor-4.0.3.tar.bz2"
  sha256 "ae9813a64d13d9ebe4b44e89e8e4e44fc438693b6ce4c3a98e4cab1af22d9627"

  bottle do
    sha256 "f044aeacd64def9fa7f2bb0bd2c6dd601c324e3f030038a2f7914785552b3fbd" => :sierra
    sha256 "448d129e699d87c89bbe28069ad4af8eb4f53a074ea6acbf6ffd71547af9f926" => :el_capitan
    sha256 "a33ef50799e0c20945040d5ac6b1bb511f3d5b12825c61de4905334aaf28d5de" => :yosemite
    sha256 "0168f90f28a6daea7175506219f671bda429c95d5daa112c3a695a6c3c1c5edb" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "openssl"
  depends_on "lua"
  depends_on "gcc" if DevelopmentTools.clang_build_version <= 600

  needs :cxx11

  fails_with :clang do
    build 600
    cause "incomplete C++11 support"
  end

  # Remove for > 4.0.3
  # Upstream commit "rec: Fix Lua-enabled compilation on macOS and FreeBSD"
  patch :p2 do
    url "https://github.com/PowerDNS/pdns/commit/546d1fb.patch"
    sha256 "9a7711596aebaf3eceaf8abcf723df12aa9c22583e6bb177b4eb0f90c8bb2ec3"
  end

  def install
    ENV.cxx11

    # Remove for > 4.0.3; using inreplace avoids Autotools dependencies
    # Upstream PR "Fall back to SystemV ucontexts on boost >= 1.61"
    # See https://github.com/PowerDNS/pdns/commit/fbf562c
    inreplace "configure", "boost/context/detail/fcontext.hpp",
                           "boost/context/fcontext.hpp"

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
