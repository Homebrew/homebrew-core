class FreeradiusServer < Formula
  desc "High-performance and highly configurable RADIUS server"
  homepage "https://freeradius.org/"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
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
    sha256 arm64_ventura:  "26c7e0343035fbaee6461e9559210e6a82a1072589fd64f814e744a3d2dc6126"
    sha256 arm64_monterey: "7cdb8ed4cba08c375fae7d9e534b4c1bd31c71ce8fba637a25b08b1e8784ae95"
    sha256 arm64_big_sur:  "3736781e5be515619cb0a9750f9c1100e6518d2b5fc54957defb1947e6fe9432"
    sha256 ventura:        "1ca7631e75d7a7b94ba87c55ca47ff2f07482f9d6502a19c5a7e05d72b6b99f0"
    sha256 monterey:       "86a65b62f8baa4b585a0384a2a0098474093167c84b9976c3a555f1a3c32d359"
    sha256 big_sur:        "f41f5aae980d220134df44de2297cff8f2fa34410d5078ba84e6d15fbe8396db"
    sha256 x86_64_linux:   "d743c39d817f8d30eef139c5aa0b7dd36f150e873ef8107abbb02e3e40bc6362"
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
