class FreeradiusServer < Formula
  desc "High-performance and highly configurable RADIUS server"
  homepage "https://freeradius.org/"
  url "https://github.com/FreeRADIUS/freeradius-server/archive/release_3_0_23.tar.gz"
  sha256 "6192b6a8d141545dc54c00c1a7af7f502f990418d780dcae76074163070dbb86"
  license "GPL-2.0"
  head "https://github.com/FreeRADIUS/freeradius-server.git"

  livecheck do
    url :stable
    regex(/^release[._-](\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    sha256 arm64_big_sur: "96aa638cd4c28b6876bed8ebd236d5276f6b72add6a9bed3ec889a3a15b82de9"
    sha256 big_sur:       "ab19adc5c1021e8d6ef924afff07f32010e17bc4cc8eb4c98f9807d7d3b1cc82"
    sha256 catalina:      "725f71cf758fe8f21eb53317b516260a9d38337ce4d28172cc5c65c6b337a5b1"
    sha256 mojave:        "666a6ac614e06cb9d03cc2c8b4a2279153db994c76975d6a735d8596b87d7996"
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
