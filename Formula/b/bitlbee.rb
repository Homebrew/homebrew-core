class Bitlbee < Formula
  desc "IRC to other chat networks gateway"
  homepage "https://www.bitlbee.org/"
  url "https://get.bitlbee.org/src/bitlbee-3.6.tar.gz"
  sha256 "9f15de46f29b46bf1e39fc50bdf4515e71b17f551f3955094c5da792d962107e"
  license "GPL-2.0-or-later"
  head "https://github.com/bitlbee/bitlbee.git", branch: "master"

  livecheck do
    url "https://get.bitlbee.org/src/"
    regex(/href=.*?bitlbee[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "31ddec7ca433f3bcf5dc5f86206c99464e9586065bf0fbb54b327051ff751dff"
    sha256 arm64_sequoia: "6a753f8b6013608e71d728f3a7143a3d53656c90c09b52177a0322739f952525"
    sha256 arm64_sonoma:  "71c5c8da85fb73d4e4bc66f83283c2e3b30e640ce769a92eb781b1867cc720f4"
    sha256 sonoma:        "6676fbaaf43d2568ba44b99fffe99daf672f15e61838e3a993843f7782209d01"
    sha256 arm64_linux:   "1277ebd34ba641c76ca3aa2cc366d8a88ac80abf9bd60bea1c71519cd4426a27"
    sha256 x86_64_linux:  "c7a641730d68f5399b8b322761e21cef1cacce0e532fd7f5ded9202c39599ad9"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "libgpg-error"

  on_macos do
    depends_on "gettext"
  end

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
