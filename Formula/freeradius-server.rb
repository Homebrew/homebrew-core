class FreeradiusServer < Formula
  desc "High-performance and highly configurable RADIUS server"
  homepage "https://freeradius.org/"
  url "https://github.com/FreeRADIUS/freeradius-server/archive/release_3_0_18.tar.gz"
  sha256 "c6802e3ec675b1cf59c850b0f01ed088e2983c5c4daa7f64cc22be4e6ad13ae5"
  head "https://github.com/FreeRADIUS/freeradius-server.git"

  bottle do
    sha256 "d1c7435e989a36eccd350d10060e7166b279dbdcdab4f6c6f3fcd2456871536d" => :mojave
    sha256 "28129f8061b40d0d0890489d7ccafb648c640483602d2849aaa19379ed0b4955" => :high_sierra
    sha256 "2ca7b26cb4de48e14bc4bd85f23c0913319f2c2234c32fde7f124d21c9ea575e" => :sierra
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
