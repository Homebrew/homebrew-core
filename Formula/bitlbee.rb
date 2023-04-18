class Bitlbee < Formula
  desc "IRC to other chat networks gateway"
  homepage "https://www.bitlbee.org/"
  license "GPL-2.0"
  head "https://github.com/bitlbee/bitlbee.git", branch: "master"

  stable do
    url "https://get.bitlbee.org/src/bitlbee-3.6.tar.gz"
    sha256 "9f15de46f29b46bf1e39fc50bdf4515e71b17f551f3955094c5da792d962107e"
  end

  livecheck do
    url "https://get.bitlbee.org/src/"
    regex(/href=.*?bitlbee[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "d5abbf75f2d71752b48051f6072394422a338650a187b53f0bcb528981da9e3a"
    sha256 arm64_monterey: "6c291e3c2ef13b1e766bbfa75f7732f273cacdd6eb98bfdd474db446a8ae0137"
    sha256 arm64_big_sur:  "664ce4fbb775206950ec7b0786bcefc43c43ead3631a33024061dd139b59ecfe"
    sha256 ventura:        "e74d65e09581d5e67cb6e7f495e7070bae95d4a51e5449f86b5fb9b44af6aa9c"
    sha256 monterey:       "58b2fb9b50a1c3ed78f9b8945abb8aa883da058170cd0255a44f01681c660f6c"
    sha256 big_sur:        "3d4a68524f64b5abca2cdb3cca9eb60fe6ab30c98bd12cddf4f736fb3c1dda54"
    sha256 catalina:       "c7280a6ea53c3336f710b12617c2fa68bd4b75829962728002f72006e3163ffc"
    sha256 x86_64_linux:   "046736bbc9acefad55c69d5acbe77d4f96123d6a1ab49db0179d95f5cb72eec6"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "libgcrypt"

  def install
    args = %W[
      --prefix=#{prefix}
      --plugindir=#{HOMEBREW_PREFIX}/lib/bitlbee/
      --debug=0
      --ssl=gnutls
      --etcdir=#{etc}/bitlbee
      --pidfile=#{var}/bitlbee/run/bitlbee.pid
      --config=#{var}/bitlbee/lib/
      --ipsocket=#{var}/bitlbee/run/bitlbee.sock
    ]

    system "./configure", *args

    # This build depends on make running first.
    system "make"
    system "make", "install"
    # Install the dev headers too
    system "make", "install-dev"
    # This build has an extra step.
    system "make", "install-etc"
  end

  def post_install
    (var/"bitlbee/run").mkpath
    (var/"bitlbee/lib").mkpath
  end

  service do
    run opt_sbin/"bitlbee"
    sockets "tcp://127.0.0.1:6667"
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/bitlbee -V", 1)
  end
end
