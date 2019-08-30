class FreeradiusServer < Formula
  desc "High-performance and highly configurable RADIUS server"
  homepage "https://freeradius.org/"
  url "https://github.com/FreeRADIUS/freeradius-server/archive/release_3_0_19.tar.gz"
  sha256 "34c50ac47a683b13eae1a02f2d0263c0bd51a83f01b99c02c5fe25df07a1ee77"
  revision 1
  head "https://github.com/FreeRADIUS/freeradius-server.git"

  bottle do
    sha256 "7a2a426654c18300d324d10937d239815cd98f7ff0cc14ee559989556336898e" => :mojave
    sha256 "db3eff9b15d53109b5fb41c39ffecb27191733e1deaba62e17ec21bb249aab31" => :high_sierra
    sha256 "c2ff882edd53c1644843e29b23cc11b160dea126be8016925514fc34976b4f58" => :sierra
  end

  depends_on "openssl@1.1"
  depends_on "talloc"
  uses_from_macos "perl"

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
