class FreeradiusServer < Formula
  desc "High-performance and highly configurable RADIUS server"
  homepage "https://freeradius.org/"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 2
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
    rebuild 1
    sha256 arm64_sonoma:   "975eb3ec60ead242efbddafd806f7221ca8d620d834596223cb06b1dc1757e6b"
    sha256 arm64_ventura:  "37734c06c9574c408e54949be5cbd8d5bd854cc1ee62a38db20e59e0c40099b9"
    sha256 arm64_monterey: "7a44daa75f6580de3b0c94272a7f9571f7a980479605ec0ed3cb758ce62efd47"
    sha256 sonoma:         "d363438223648119548525ad6445ba46637fc98826abdb901a738975ba5b9a7b"
    sha256 ventura:        "288de84c2b4f3c8af2c818ccb9663acddf3844e37563196eb7dccf49f6a77d9f"
    sha256 monterey:       "f0ca09ead3c4384d90869155652a4181402da2c9c1281d6522ee2e3246c652fb"
    sha256 x86_64_linux:   "3d3bb2b2e6a477690ac32054c51e1f01c7ebbed5c8580123f3b0afae6a85308b"
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
    output = shell_output("#{bin}/smbencrypt homebrew")
    assert_match "77C8009C912CFFCF3832C92FC614B7D1", output
  end
end
