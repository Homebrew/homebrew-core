class FreeradiusServer < Formula
  desc "High-performance and highly configurable RADIUS server"
  homepage "https://freeradius.org/"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  head "https://github.com/FreeRADIUS/freeradius-server.git", branch: "master"

  stable do
    url "https://github.com/FreeRADIUS/freeradius-server/archive/refs/tags/release_3_2_4.tar.gz"
    sha256 "0764c83dd4e05ce33ed01eddaf68c68bfb4f2a6010d5256d7a97916375d010d4"

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
    sha256 arm64_sonoma:   "19edf5be6447f8c62ee038ad55d006dbe7c29a5ac39493afa2d4bda80549666b"
    sha256 arm64_ventura:  "60e9474ef001cc9f684a2427cd00379653c51f418b33c495ad91bd4295889d5e"
    sha256 arm64_monterey: "23bf465f2eb4a606769d5dcc088394650b5a8dcc4b8c52e849a0d5167eba3aea"
    sha256 sonoma:         "00959440feafa2d36e7800b3808f6fcf257dcc0f2338c8945f03abdfc607c8e3"
    sha256 ventura:        "84300f558706ce2ef1fb66b76447430c1ce5a762b06ff4bc3237e556e008f161"
    sha256 monterey:       "2d482b7d4602745e57ae9fb8047018ba348bdb37a2231d74358ac2e586d05754"
    sha256 x86_64_linux:   "133cf435320e3e5e9728f318514c7ef07d9a0cedcead7a05ee5c882f597d5eb7"
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
