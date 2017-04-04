class FreeradiusServer < Formula
  desc "High-performance and highly configurable RADIUS server"
  homepage "https://freeradius.org/"
  url "ftp://ftp.freeradius.org/pub/freeradius/freeradius-server-3.0.13.tar.bz2"
  sha256 "b3be0d8849878c31af0a5375d20b7b20c9d1c1572e89dc3f22992824cefffb84"
  head "https://github.com/FreeRADIUS/freeradius-server.git"

  bottle do
    sha256 "4c4ae27b8a8da9ad1356b26ab7a92bac5f676707a0928a42bef5f60a549663e5" => :sierra
    sha256 "934318a5f1dcdc070ea0260d1709a177b1efeb6347296c6bdb4e69cd9b54636d" => :el_capitan
    sha256 "6ceca0a4e7f7ce6e7e9e246b4b8f1b2ac7cfbbeeceb895909cbbf4e77638d5f0" => :yosemite
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
    assert_match /77C8009C912CFFCF3832C92FC614B7D1/, shell_output("#{bin}/smbencrypt homebrew")
  end
end
