class FreeradiusServer < Formula
  desc "High-performance and highly configurable RADIUS server"
  homepage "https://freeradius.org/"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 1
  head "https://github.com/FreeRADIUS/freeradius-server.git", branch: "master"

  stable do
    url "https://github.com/FreeRADIUS/freeradius-server/archive/refs/tags/release_3_2_3.tar.gz"
    sha256 "65cdb744471895ea1da49069454a9a73cc0851fba97251f96b40673d3d54bd8f"

    # Fix -flat_namespace being used
    patch do
      url "https://github.com/FreeRADIUS/freeradius-server/commit/6c1cdb0e75ce36f6fadb8ade1a69ba5e16283689.patch?full_index=1"
      sha256 "7e7d055d72736880ca8e1be70b81271dd02f2467156404280a117cb5dc8dccdc"
    end
  end

  livecheck do
    url :stable
    regex(/^release[._-](\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "a1d0365d2e2691b27dcc9b90c458b47439a4982e5b9febc71f359090a66996c5"
    sha256 arm64_monterey: "e0544f9dc04f088159188525ef735abe4aaf81d3f6e4cb983707c8b7dab7055b"
    sha256 arm64_big_sur:  "5221b0210a9742206fa1ec17028840f3f6537abb9445bc8f5aa6cfdf1dfc07be"
    sha256 ventura:        "625efc911ce3dfc8351f92a9ece000b0d57762e78f1cf41959c3b211d4c8f61a"
    sha256 monterey:       "b4131c02646af440971ac250e4587a4775213e6ad55c308cd9266926c68afd9b"
    sha256 big_sur:        "740b5d0428ea03b63b6d16d4277b35116379e6f012cc8e41d7d4ad117d8c56df"
    sha256 x86_64_linux:   "a093484fb609b8e8c429f32a251f14333e23148425bdb68e6b9c4b41c7a8f6f2"
  end

  depends_on "collectd"
  depends_on "openssl@3"
  depends_on "python@3.11"
  depends_on "talloc"

  uses_from_macos "krb5"
  uses_from_macos "libpcap"
  uses_from_macos "libxcrypt"
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
      --with-openssl-includes=#{Formula["openssl@3"].opt_include}
      --with-openssl-libraries=#{Formula["openssl@3"].opt_lib}
      --with-talloc-lib-dir=#{Formula["talloc"].opt_lib}
      --with-talloc-include-dir=#{Formula["talloc"].opt_include}
    ]

    args << "--without-rlm_python" if OS.mac?

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
