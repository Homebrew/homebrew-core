class FreeradiusServer < Formula
  desc "High-performance and highly configurable RADIUS server"
  homepage "https://freeradius.org/"
  url "https://github.com/FreeRADIUS/freeradius-server/archive/refs/tags/release_3_2_8.tar.gz"
  sha256 "7a42562d4c1b0dfd67783b995b33df6ea0983573b2a3b2b99c368dda647e562c"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  head "https://github.com/FreeRADIUS/freeradius-server.git", branch: "master"

  livecheck do
    url :stable
    regex(/^release[._-](\d+(?:[._]\d+)+)$/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 arm64_tahoe:   "cb979e4c7b3f1b85d374fa5be895081dc7e31904cf87539b3d6f7e7d0d96c79e"
    sha256 arm64_sequoia: "6063a6adaebb53d19c4677da34e9fbb92682875047d17ec465394d7bd3018a03"
    sha256 arm64_sonoma:  "8a80dda119bb5a5a1d3a0f3494699185751383275f0bfcfad217c32bcc5601f1"
    sha256 arm64_ventura: "ab409f75783ba2740ac66a4caaae1b2dfcc325cf24d982b1b7b3aa35a1e1afca"
    sha256 sonoma:        "0efd2ad25501001b530f1373a684881b02c7ad06c8829be91b3427a57e40bf72"
    sha256 ventura:       "f4f9bef36f34e50e16a086913cdd0c0d82b9b6bec9436ad99d7d2467861ef7c5"
    sha256 arm64_linux:   "df9ea57c317949304f50d7c3811556b7819fbd68cc67b2656f2d69cfd671bf14"
    sha256 x86_64_linux:  "cdc657b0560a0a8e1cf68496c5104bff301daa10cb5150953cbcbd515034d326"
  end

  depends_on "collectd"
  depends_on "json-c"
  depends_on "openssl@3"
  depends_on "python@3.13"
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
