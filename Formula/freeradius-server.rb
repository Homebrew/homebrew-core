class FreeradiusServer < Formula
  desc "High-performance and highly configurable RADIUS server"
  homepage "https://freeradius.org/"
  url "ftp://ftp.freeradius.org/pub/freeradius/freeradius-server-3.0.15.tar.bz2"
  sha256 "23267d8505e7b2909f5bdbf3938ca077c1fe122290dc969304d4f3b594f7e3ba"
  head "https://github.com/FreeRADIUS/freeradius-server.git"

  bottle do
    sha256 "ff932637e3ec318b58513eae08c1f5e8dbfe6ae1ec7754f1e7eee0c009c51d2f" => :sierra
    sha256 "759a444aec877b3ab6d06938fbb7b01a4ab7e7302e8ad5843837187dacc30973" => :el_capitan
    sha256 "65f998ce03daee3c05bb02cc83ac8de864c47193fdc4637305edb2dfea6c2260" => :yosemite
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
