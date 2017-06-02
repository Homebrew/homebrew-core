class FreeradiusServer < Formula
  desc "High-performance and highly configurable RADIUS server"
  homepage "https://freeradius.org/"
  url "ftp://ftp.freeradius.org/pub/freeradius/freeradius-server-3.0.14.tar.bz2"
  sha256 "2771f6ecd6c816ac4d52b66bb8ae6781ca20e1e4984c5804fc4e67de3a807c59"
  revision 1
  head "https://github.com/FreeRADIUS/freeradius-server.git"

  bottle do
    sha256 "90fcb452989cdf3f7e5dd37a9a9df870ff9c644e2263f84c19faeaedfbfaff90" => :sierra
    sha256 "39934a4c1dbe1a9c2412ff42c885b0b0cae7877c33d0cfeaa891914e5430eb9d" => :el_capitan
    sha256 "c9b8955f905b2207454a49a8c769b79cc26b63d0dd046a38d40bf68b80213da9" => :yosemite
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
