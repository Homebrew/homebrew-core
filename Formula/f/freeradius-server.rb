class FreeradiusServer < Formula
  desc "High-performance and highly configurable RADIUS server"
  homepage "https://freeradius.org/"
  url "https://github.com/FreeRADIUS/freeradius-server/archive/refs/tags/release_3_2_7.tar.gz"
  sha256 "ebb906a236a8db71ba96875c9e53405bc8493e363c3815af65ae829cb6c288a3"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  head "https://github.com/FreeRADIUS/freeradius-server.git", branch: "master"

  livecheck do
    url :stable
    regex(/^release[._-](\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "95cb101c2859a0765631f98c22516ec0ef7f04dca8e54a1eec172e6cb6d529c2"
    sha256 arm64_sonoma:  "85dfb2f19b835f7a1e3591fc936c03abf32fa80c2e9bede757be2654c0cd160d"
    sha256 arm64_ventura: "88f6183dc294964a3f22fc633249e491d6b9259368a59afc9bd4d9551af0d529"
    sha256 sonoma:        "aa58c0ce790ce38f752530797991d9d2121a184d92cea2595e77989f91fc7057"
    sha256 ventura:       "7827599b93f900268d966f9824471d36bea66fad37b64a60b470669b05787a6e"
    sha256 arm64_linux:   "9216b4e057a153ab752599e306e70a7c861bb5421e8fe3aebc72b521e9cd5579"
    sha256 x86_64_linux:  "8afee38a329ed1deed63477166edb60e3588399ae8ab116e050ee2fdd162d4d1"
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
