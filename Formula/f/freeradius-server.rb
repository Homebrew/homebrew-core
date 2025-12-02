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
    rebuild 2
    sha256 arm64_tahoe:   "08583c74bf8b89a84014c0a9d5402b623f4a5ed66d2394781890f7f6f3986128"
    sha256 arm64_sequoia: "69ae994e8b9bda3d8527e73efd256a667aecf01582804341886442424a003e64"
    sha256 arm64_sonoma:  "823766adb7a47ac2527f096027f44c2f1ee7935bd3f7fa0e4a6ab5d0db8e8f3b"
    sha256 sonoma:        "e22510d9da15a11b7e40390c0068741b68727802028b6cf287062fed94d7244a"
    sha256 arm64_linux:   "1b41a36117e846684dfdd8b6d82347bd2508b58375b262e088e42eb10faa6ba1"
    sha256 x86_64_linux:  "f3a1ee2b6cbc4d5f39d6dd37cac203c61db09a9923b6c7d0a5933208a6d24245"
  end

  depends_on "collectd"
  depends_on "json-c"
  depends_on "openssl@3"
  depends_on "python@3.14"
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
      --sbindir=#{bin}
      --localstatedir=#{var}
      --with-openssl-includes=#{Formula["openssl@3"].opt_include}
      --with-openssl-libraries=#{Formula["openssl@3"].opt_lib}
      --with-talloc-lib-dir=#{Formula["talloc"].opt_lib}
      --with-talloc-include-dir=#{Formula["talloc"].opt_include}
    ]
    args << "--without-rlm_python" if OS.mac?

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"

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
