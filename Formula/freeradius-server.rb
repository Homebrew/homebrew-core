class FreeradiusServer < Formula
  desc "High-performance and highly configurable RADIUS server"
  homepage "https://freeradius.org/"
  url "https://github.com/FreeRADIUS/freeradius-server/archive/release_3_0_17.tar.gz"
  sha256 "5b2382f08c0d9d064298281c1fb8348fc13df76550ce7a5cfc47ea91361fad91"
  head "https://github.com/FreeRADIUS/freeradius-server.git"

  bottle do
    sha256 "3966eb7c2b7d70695df7c8a9bae3476d94f47d66eded6cbe3e718e8d404198aa" => :mojave
    sha256 "038ea0b2497cf0460473eb660fe8dc770cfa7e1d9fc603015194e6a9c3a8dfd0" => :high_sierra
    sha256 "2ef3f4689ca57e28836b3501a520b731b5510e7ec62a601ae6af4f1bec54067d" => :sierra
    sha256 "4a8d696e3532c98b027a6fb9e4b9a8a6472a80800c187902cbd5d37d44579fe7" => :el_capitan
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
