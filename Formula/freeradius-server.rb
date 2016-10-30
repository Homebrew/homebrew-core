class FreeradiusServer < Formula
  desc "High-performance and highly configurable RADIUS server"
  homepage "https://freeradius.org/"
  url "ftp://ftp.freeradius.org/pub/freeradius/freeradius-server-3.0.12.tar.bz2"
  sha256 "fe4e1f52cc2873f6aee2b12b0f03236978e4632f2acf298f834686b240c4183d"
  head "https://github.com/FreeRADIUS/freeradius-server.git"

  bottle do
    sha256 "e4d007b16ac62f010ed4aead35c17697f72e97a2d4d73a54ed7af22d43ca5524" => :sierra
    sha256 "019f39ca70a186fdedb1f1ede009134fedae5b53b90a4dbb6c6dcba6cc92213e" => :el_capitan
    sha256 "a0661e889d4171401e4a767b6f6df58188b1cb29f6e17e9d2f0b34c12598a7b3" => :yosemite
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
