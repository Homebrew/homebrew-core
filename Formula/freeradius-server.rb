class FreeradiusServer < Formula
  desc "High-performance and highly configurable RADIUS server"
  homepage "https://freeradius.org/"
  url "https://github.com/FreeRADIUS/freeradius-server/archive/release_3_0_25.tar.gz"
  sha256 "493b0b9bef3d9f0e6949fcfd6aa282164f6b8e6404231f2b0d1353739199ffcd"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  head "https://github.com/FreeRADIUS/freeradius-server.git"

  livecheck do
    url :stable
    regex(/^release[._-](\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    sha256 arm64_big_sur: "f4ed69d19363b792ffba75c41b703bd6f068a2d65d76a3046ba6947832b6a6b3"
    sha256 big_sur:       "a28e06a16084beb496edcb341dcf5aaf7f6da6ef995bd7383545d59aac76f393"
    sha256 catalina:      "6fe8001066708fc01ba0c71a7a0246aee4af4910a68f155d82fd411a7a826c1b"
    sha256 mojave:        "660eb25588c2d0c68aae1684bfc9f9174c6c6d4d721d196a6232c981718e9ebf"
    sha256 x86_64_linux:  "d71cb20afdd11e9793b6299e241474f8f4d07174625809f07f228ec06cfeb950"
  end

  depends_on "openssl@1.1"
  depends_on "talloc"

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
