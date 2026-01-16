class FreeradiusServer < Formula
  desc "High-performance and highly configurable RADIUS server"
  homepage "https://freeradius.org/"
  url "https://github.com/FreeRADIUS/freeradius-server/archive/refs/tags/release_3_2_8.tar.gz"
  sha256 "7a42562d4c1b0dfd67783b995b33df6ea0983573b2a3b2b99c368dda647e562c"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 1
  head "https://github.com/FreeRADIUS/freeradius-server.git", branch: "master"

  livecheck do
    url :stable
    regex(/^release[._-](\d+(?:[._]\d+)+)$/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 arm64_tahoe:   "d3f0e7b7ab81d4933f413d642e00cd0792699e31fc0c2d623a3b3107c0bf887d"
    sha256 arm64_sequoia: "4cbcb14142ff5d4abb9adcbf26c497180acf36fa927aa01cc5f2e9780418ee9a"
    sha256 arm64_sonoma:  "bba6ba7e7ab32a5e4b47a80974960204388570eadd3262f63a97bf6c092876d6"
    sha256 sonoma:        "a5c62d00dbebc8f37c318af0389da842d670dd09c470c3a2d0c7c86a1d5acdf8"
    sha256 arm64_linux:   "d163e136724def827bb368e19d417465fa264d7171db9d6ac4d6381d9a410dc1"
    sha256 x86_64_linux:  "e316f4497fe6c34a4a7ead7cc8b538e89de27041f9e4df8b784e1b794cf5b347"
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
