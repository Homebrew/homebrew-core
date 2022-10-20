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
    sha256 arm64_monterey: "3a72087c74824a9a091929fa90f0e3832fc756e2d36310afffb9bd10e31c1b03"
    sha256 arm64_big_sur:  "1b14221525a9329fbf1e28d4c0893e130717ddede1935df4af9dbcab044c199b"
    sha256 monterey:       "3aedd8b58af6e9c58d2e96cdc0e541e9c96bf8a7ed24165fa138d54b5044edbb"
    sha256 big_sur:        "dad6720fdc5a098cedbff433883ce7e1098c3e16dc0870b810929ca371b0fdd2"
    sha256 catalina:       "52da03d26df7e96ae71125343859b754e24146c8ad5e6c58bc33eb634862ef40"
    sha256 mojave:         "d6f39cdbf633e779a47d625e8c62393d75fe1656d4d1d8cbe342940fb65cba53"
    sha256 high_sierra:    "cefcf70546bf4746913b64ee8c282deb9ca15ffb61a0e564f3f1dc8da09fb447"
    sha256 x86_64_linux:   "47b82ca433b0a6735e7941751f0cd4b50cbb097bca45069a2f95f1e4503ed770"
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
