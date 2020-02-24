class FreeradiusServer < Formula
  desc "High-performance and highly configurable RADIUS server"
  homepage "https://freeradius.org/"
  url "https://github.com/FreeRADIUS/freeradius-server/archive/release_3_0_20.tar.gz"
  sha256 "8177fe550af6685a040884dbe3df28431bdc5a8d3a48a9f4f88bdb49f2d0e90c"
  head "https://github.com/FreeRADIUS/freeradius-server.git"

  bottle do
    sha256 "7fec2abc865717382300b1d55aa344fddd7fc52b4f6b10d28636fb98885dcefa" => :catalina
    sha256 "1a5e48ff54c61244871fe183657d19b61ad0e4d83856c6fa32d455106727001a" => :mojave
    sha256 "9e66599c564de99b959b348f2e24f5bd97e3975f4c1904f71bfd07c783748a08" => :high_sierra
  end

  depends_on "openssl@1.1"
  depends_on "talloc"

  uses_from_macos "perl"
  uses_from_macos "readline"
  uses_from_macos "sqlite"

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
