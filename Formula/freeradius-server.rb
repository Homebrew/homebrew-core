class FreeradiusServer < Formula
  desc "High-performance and highly configurable RADIUS server"
  homepage "https://freeradius.org/"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  head "https://github.com/FreeRADIUS/freeradius-server.git", branch: "master"

  stable do
    url "https://github.com/FreeRADIUS/freeradius-server/archive/refs/tags/release_3_2_1.tar.gz"
    sha256 "95c18c5489564b5a07ef5e64f6685dbe1415f690ceb46f0706d422b8e8a29b52"

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
    sha256 arm64_ventura:  "3a9c45b654f9936b59c1dd18fd61dbef5e2c740869f60bb5843dc895c3971b65"
    sha256 arm64_monterey: "41557555af1157aa2caa71bde5149523405f898b37c303b8c5501c4dd17bc3d8"
    sha256 arm64_big_sur:  "e4a7493d32a60bd8b58d4896a99e89fd353d59978ecb9d9dbdd5aa14c45384f4"
    sha256 ventura:        "fe89d6ed617b6b35ce5cea239fbd28bd324aed8d4e661933abe16d1b6484ba16"
    sha256 monterey:       "3d123e9f63012690a85de802752edd3bc45a0d0985e6368a09c0002efce5263a"
    sha256 big_sur:        "a6190c53bec5379b83525fcc49a557ea23bb708f816bcdf279e30bed43b96cd7"
    sha256 catalina:       "4a5ace706738767b3e1dd02a7be32b4474a94797a914090c9ccf2150d670be80"
    sha256 x86_64_linux:   "a147047b34df9e2bf59d84fb24aef5b70d2e0c1c1b3794d778d677fc395e9fd8"
  end

  depends_on "collectd"
  depends_on "openssl@1.1"
  depends_on "python@3.10"
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
