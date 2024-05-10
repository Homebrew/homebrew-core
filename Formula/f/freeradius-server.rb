class FreeradiusServer < Formula
  desc "High-performance and highly configurable RADIUS server"
  homepage "https://freeradius.org/"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 4
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
    sha256 arm64_sonoma:   "813a586b28502bb65ecf7b219b8c4f453c2be602c4d22ae9e6acedcbe7dba261"
    sha256 arm64_ventura:  "a3b350ba4693c8ef7c569181b838335087db6c0f2e202eb35252afa041e9069a"
    sha256 arm64_monterey: "4701828525754c3696bbc2aad476c4791170d932b222ee7fec84beaa34159bdb"
    sha256 sonoma:         "3f70ad4001df9d13fa3de810e21b960cffc81d583da437faeb3de1f1fd6bbbbe"
    sha256 ventura:        "23847bbd5bd1d05407bb4776683658d39a0b5f277dfab68de056044b1edfebe7"
    sha256 monterey:       "e3d590372d756cd494628c5c57144c4a6c10c5bfd693de68aee6fd821dd202e8"
    sha256 x86_64_linux:   "c25868df8d318a2662d3fe296120cf226eb282f4d1a2667b64f206d7a57d667b"
  end

  depends_on "collectd"
  depends_on "openssl@3"
  depends_on "python@3.12"
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
    assert_match "77C8009C912CFFCF3832C92FC614B7D1",
                 shell_output("#{bin}/smbencrypt homebrew")

    assert_match "Configuration appears to be OK",
                 shell_output("#{bin}/radiusd -CX")
  end
end
