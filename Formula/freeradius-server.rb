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
    sha256 arm64_big_sur: "0ec020d5681af819217e88d69b32847374d2c741bc6c014019d9eab7c115f826"
    sha256 big_sur:       "2391ba3cd210a510891422e50436c6d9f6f6da3e7a98b3db3d2c8ea0f3bba310"
    sha256 catalina:      "ecbed108fde03090c41450fd0faab9ad0c6f5a1727a43d4c4b6e3519d9b607d9"
    sha256 mojave:        "da0356738b1575a928df644cd554876510ff45ea1c0ead6e86ccc9a0aa70bc11"
    sha256 x86_64_linux:  "e1cf4c5f2a4b5f4115691657761b9da118fd4f9f4f4ae474c774969bb094b1b9"
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
