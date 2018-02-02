class FreeradiusServer < Formula
  desc "High-performance and highly configurable RADIUS server"
  homepage "https://freeradius.org/"
  url "ftp://ftp.freeradius.org/pub/freeradius/freeradius-server-3.0.16.tar.bz2"
  sha256 "120cb1b75b434f8a2a9f9813da6df99ab92b8e6e24980353f314b04f517e0d84"
  head "https://github.com/FreeRADIUS/freeradius-server.git"

  bottle do
    sha256 "ab26718f1e43040d1434b3e8b4d3a853a5a7188bf0b1fe243116a5b508656493" => :high_sierra
    sha256 "9006602a414819b26e61825fc58b612b573a89752ca917e29a612ca6c8499807" => :sierra
    sha256 "63b13e5024c636646078d5a6719996ce753e11b69e41751354db7e3068e1a132" => :el_capitan
  end

  depends_on "openssl"
  depends_on "talloc"

  def install
    ENV.deparallelize

    args = %W[
      --prefix=#{prefix}
      --sbindir=#{bin}
      --localstatedir=#{var}
      --with-openssl-includes=#{Formula["openssl"].opt_include}
      --with-openssl-libraries=#{Formula["openssl"].opt_lib}
      --with-talloc-lib-dir=#{Formula["talloc"].opt_lib}
      --with-talloc-include-dir=#{Formula["talloc"].opt_include}
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  def post_install
    (var/"run/radiusd").mkpath
    (var/"log/radius").mkpath
  end

  test do
    output = shell_output("#{bin}/smbencrypt homebrew")
    assert_match "77C8009C912CFFCF3832C92FC614B7D1", output
  end
end
