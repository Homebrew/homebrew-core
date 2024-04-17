class FreeradiusServer < Formula
  desc "High-performance and highly configurable RADIUS server"
  homepage "https://freeradius.org/"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 3
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
    sha256 arm64_sonoma:   "8e2c7f1308ab341f32ba8ca96a0cd1cd1c94e53bd448236d3646d92bd303b71e"
    sha256 arm64_ventura:  "02c1d0da35f4760096dce6a336bef21c3185476c28f6eb33b28ab62fb2f07601"
    sha256 arm64_monterey: "ae339ff81424bfb9f9fd6dcd06e59017b420ce42c9338605995b87fff4b10089"
    sha256 sonoma:         "cbcbcda4abccda97c70292de45f256410e5419f8877105aa259ad97df53154e3"
    sha256 ventura:        "f31550a68c75e78964b283840a062414fd07063d2f6b2580411382edb53385b3"
    sha256 monterey:       "05d2e324045c9e03bb0db3739ac9ae96ba6ead37c9775cdb06bcbf311847dfcb"
    sha256 x86_64_linux:   "44b92061c97ef0b377d3b041229288e19b31ac0723cb1686aad0249897aafc08"
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
