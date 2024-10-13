class FreeradiusServer < Formula
  desc "High-performance and highly configurable RADIUS server"
  homepage "https://freeradius.org/"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  head "https://github.com/FreeRADIUS/freeradius-server.git", branch: "master"

  stable do
    url "https://github.com/FreeRADIUS/freeradius-server/archive/refs/tags/release_3_2_6.tar.gz"
    sha256 "65e099edf5d72ac2f9f7198c800cf0199544f974aae13c93908ab739815b9625"

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
    sha256 arm64_sequoia:  "b57698488a0307b2f51fe141e52c4da6126901ce43516cc0bbf66bff100907d1"
    sha256 arm64_sonoma:   "03ac0c2ee9d93ae9bc4b7f28b35d67eeba3b699078eaa782155a5c7355424dc4"
    sha256 arm64_ventura:  "42af2bf53bd21966d2a2048881f5b6773c935d1db77227f2d42d96c074b93734"
    sha256 arm64_monterey: "baf53a6faa43f12e55bdd0ad39ad7b1bd00e90db782bab615c261c165ea764f9"
    sha256 sonoma:         "1c647250256f77554efdd419b2757e959ad0123ca8ac7ca342f26384c70ae88e"
    sha256 ventura:        "da61e1b705d1af4903ce70f2d94e85b7abcc34ca4db039eaccdde4d0ba72e7d8"
    sha256 monterey:       "677823159554422189b154388db1ac27c4300a911220e6135a8e9eb06b9571c5"
    sha256 x86_64_linux:   "b2a0d3866dfdb56a732021856ce0dd4250f32adf595dc0353905eab037143877"
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
