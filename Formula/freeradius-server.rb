class FreeradiusServer < Formula
  desc "High-performance and highly configurable RADIUS server"
  homepage "https://freeradius.org/"
  url "ftp://ftp.freeradius.org/pub/freeradius/freeradius-server-3.0.15.tar.bz2"
  sha256 "23267d8505e7b2909f5bdbf3938ca077c1fe122290dc969304d4f3b594f7e3ba"
  head "https://github.com/FreeRADIUS/freeradius-server.git"

  bottle do
    sha256 "f0a1016c6df804583e42d458be1f9f26c3fc70a904657f6732a233fe84f1a425" => :sierra
    sha256 "ab2d430e1198fd82e12ba2e7695235ee00113a397f835f059d6679277a8d1c55" => :el_capitan
    sha256 "021a45cffae2aef7b1d150d45c1fb2c00a75194ce940ee06d6903fec86c686da" => :yosemite
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
