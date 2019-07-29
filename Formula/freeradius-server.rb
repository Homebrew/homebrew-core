class FreeradiusServer < Formula
  desc "High-performance and highly configurable RADIUS server"
  homepage "https://freeradius.org/"
  url "https://github.com/FreeRADIUS/freeradius-server/archive/release_3_0_19.tar.gz"
  sha256 "34c50ac47a683b13eae1a02f2d0263c0bd51a83f01b99c02c5fe25df07a1ee77"
  head "https://github.com/FreeRADIUS/freeradius-server.git"

  bottle do
    sha256 "536c79ce65f77982ceab1f8ec47e023e46d8b78a9035f4229af5a0aed1a8f4ca" => :mojave
    sha256 "e52023a7bb402838658a7a3705fae8c5b58de339cba710a590045eb13a706652" => :high_sierra
    sha256 "da36b7c93a9e2c4b3fc58fa319fe47287c5e0eb2d6dfa702d9f95fc6424f9bff" => :sierra
  end

  depends_on "openssl"
  depends_on "talloc"
  uses_from_macos "perl"

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
