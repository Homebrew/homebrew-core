class FreeradiusServer < Formula
  desc "High-performance and highly configurable RADIUS server"
  homepage "https://freeradius.org/"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  head "https://github.com/FreeRADIUS/freeradius-server.git", branch: "master"

  stable do
    url "https://github.com/FreeRADIUS/freeradius-server/archive/refs/tags/release_3_2_1.tar.gz"
    sha256 "95c18c5489564b5a07ef5e64f6685dbe1415f690ceb46f0706d422b8e8a29b52"

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
    sha256 arm64_monterey: "ad6707cb70346259245c824f39bff8b9896123bfb45833df6ac9d4554b86b014"
    sha256 arm64_big_sur:  "d0b7693d3d2e9fa8b3af4d7c5d2570b3b0b921a459c3b7ed31e0423eb21db333"
    sha256 monterey:       "72ac37fa789fc13e6b74200ca39dd192dff12d9fd47a1937949650127fec02df"
    sha256 big_sur:        "66eb4cdc56c09983b290fb7e142f6569a6c1458e4f8106e76eb2ccd8a29fcc71"
    sha256 catalina:       "8881b0bc794b648e8939728e4bc7645634b1436450417c1412a907d2b5ea5c12"
    sha256 x86_64_linux:   "297ca779cd0a8cc6d6f05faf50b6d49bffec80034dc787674124963ba0c45d36"
  end

  depends_on "collectd"
  depends_on "openssl@1.1"
  depends_on "python@3.10"
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
