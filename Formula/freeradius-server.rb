class FreeradiusServer < Formula
  desc "High-performance and highly configurable RADIUS server"
  homepage "https://freeradius.org/"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  head "https://github.com/FreeRADIUS/freeradius-server.git", branch: "master"

  stable do
    url "https://github.com/FreeRADIUS/freeradius-server/archive/refs/tags/release_3_2_2.tar.gz"
    sha256 "c1526742249d584f069e1738541528847eb1f84ac580c52c9664f2a8463d4f36"

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
    sha256 arm64_ventura:  "ef56cb0121c62d66cb75f4cbf62e756f0d6d2efa7f50211b6aeeabaf187a5e18"
    sha256 arm64_monterey: "6c045b5f47a6d286fc86e0079916fc9a946804271ee549c1317bb0d0262f1db1"
    sha256 arm64_big_sur:  "1dbe46f88a729488bee516162b3c410a739808f0fc766cb0c48ad7a6615e135f"
    sha256 ventura:        "139810b9990dc6648df5aae923a7cbd5adb14d545c2d9caac1c4f61569380944"
    sha256 monterey:       "9f3d64de4ee24fae77c582b6415025f52aec9dfc5d26c11f12baed57d9a587a0"
    sha256 big_sur:        "641e935f66a99411a3d844da02a030e019ba1d64777608ea31f3838928e6b8f7"
    sha256 x86_64_linux:   "f347a3d72b60f7065425343a18f04b7e1ee90a70684e4fcc72dbf08ac0254b15"
  end

  depends_on "collectd"
  depends_on "openssl@1.1"
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
      --with-openssl-includes=#{Formula["openssl@1.1"].opt_include}
      --with-openssl-libraries=#{Formula["openssl@1.1"].opt_lib}
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
