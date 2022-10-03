class FreeradiusServer < Formula
  desc "High-performance and highly configurable RADIUS server"
  homepage "https://freeradius.org/"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 3
  head "https://github.com/FreeRADIUS/freeradius-server.git", branch: "master"

  stable do
    url "https://github.com/FreeRADIUS/freeradius-server/archive/refs/tags/release_3_2_0.tar.gz"
    sha256 "2b8817472847e0b49395facd670be97071133730ffa825bb56386c89c18174f5"

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
    sha256 arm64_monterey: "9e9dea579267e8dcf6d69cb874f601dcc692f58e7ccb7d11d88380f7933ea376"
    sha256 arm64_big_sur:  "5860266a3795b68fc118e19d6a2ea68bd445cc17b0869894f37decc77bb963a3"
    sha256 monterey:       "4c595dab52d2a47da202656a38031aa51edba53c89369f0eb4afb32b70aec65e"
    sha256 big_sur:        "c90fb82e17c159134073411bb5edf8b02346188db8a593b04b45a608dceb7ba6"
    sha256 catalina:       "fe6289989dcb46376ebce0ab3df3db16e52da01f86c4f5b9a9c28e152e9a83b5"
    sha256 x86_64_linux:   "7c3f7ab8b3b40bdb16f22c9d2a3e8ed9b05d5154cd8cd00ba773489dcfd8433f"
  end

  depends_on "collectd"
  depends_on "openssl@1.1"
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
