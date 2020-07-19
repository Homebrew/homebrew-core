class FreeradiusServer < Formula
  desc "High-performance and highly configurable RADIUS server"
  homepage "https://freeradius.org/"
  url "https://github.com/FreeRADIUS/freeradius-server/archive/release_3_0_21.tar.gz"
  sha256 "b2014372948a92f86cfe2cf43c58ef47921c03af05666eb9d6416bdc6eeaedc2"
  license "GPL-2.0"
  head "https://github.com/FreeRADIUS/freeradius-server.git"

  bottle do
    sha256 "c3174a08eaeabce252f16224d93fcb1503584ac6b2d7733a6e80eb558cfefee5" => :catalina
    sha256 "4c4dc47fe8af598594c4dd24184f7b5400e383e7649c6f6aa98f1663997b04ec" => :mojave
    sha256 "2c8d33eddc1311f098175f2854173bbd4181d9f20fa0d1807950a84198fca6e1" => :high_sierra
  end

  depends_on "openssl@1.1"
  depends_on "talloc"

  uses_from_macos "perl"
  uses_from_macos "sqlite"

  on_linux do
    depends_on "readline"
  end

  def install
    ENV.deparallelize

    args = %W[
      --prefix=#{prefix}
      --sbindir=#{bin}
      --localstatedir=#{var}
      --with-openssl-includes=#{Formula["openssl@1.1"].opt_include}
      --with-openssl-libraries=#{Formula["openssl@1.1"].opt_lib}
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
