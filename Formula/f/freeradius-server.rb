class FreeradiusServer < Formula
  desc "High-performance and highly configurable RADIUS server"
  homepage "https://freeradius.org/"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  head "https://github.com/FreeRADIUS/freeradius-server.git", branch: "master"

  stable do
    url "https://github.com/FreeRADIUS/freeradius-server/archive/refs/tags/release_3_2_5.tar.gz"
    sha256 "928d4ab2092b013d1b6bc7daed06171ceb6bb39f7f4a05c40769bae98a87c61c"

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
    sha256 arm64_sonoma:   "a2bb52ff286fba30bfd28d7dd60b4eb6c56e7861ce364e473a92e8c20aa970ec"
    sha256 arm64_ventura:  "8539016342ec1ff39ca3058c1dc7710e201a56746c34e8adf3cf1952bcc58b4c"
    sha256 arm64_monterey: "2148580948c2a0c30b3e67ccd82b8664ed85e8b4f8a02e2b2cf2bc80cda9774e"
    sha256 sonoma:         "14ab923c6cd7ff7fb8322b5edd8cce89887910a58da8da6fd05b6ed16ca22f41"
    sha256 ventura:        "aab1309c52e7adcaf281ed394208dbb0788ab766ae604e8724aaa14d1d49fd86"
    sha256 monterey:       "992cd8dc0e31fde51da27c3b3b39dac6bc8488a154c141e1f24b29c8a6efdd62"
    sha256 x86_64_linux:   "5d5000c90f4a69c183edada6fa349218d8597ef21b40db0b7966a70cbbdafac4"
  end

  depends_on "collectd"
  depends_on "json-c"
  depends_on "openssl@3"
  depends_on "python@3.12"
  depends_on "talloc"

  uses_from_macos "krb5"
  uses_from_macos "libpcap"
  uses_from_macos "libxcrypt"
  uses_from_macos "perl"
  uses_from_macos "sqlite"

  on_linux do
    depends_on "gdbm"
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
