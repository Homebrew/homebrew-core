class Lldpd < Formula
  desc "Implementation of IEEE 802.1ab (LLDP)"
  homepage "https://vincentbernat.github.io/lldpd/"
  url "https://media.luffy.cx/files/lldpd/lldpd-1.0.11.tar.gz"
  sha256 "b51d15700fbaefcb7fb85c3506b49d33173a0f15d700f933ef044067b42d46e4"
  license "ISC"

  livecheck do
    url "https://github.com/vincentbernat/lldpd.git"
  end

  bottle do
    rebuild 1
    sha256 arm64_big_sur: "e2af824e8a40b2e73f68f4949e502df719f04283acf4566efce7c6255c2848d4"
    sha256 big_sur:       "394eeeb77c9945f24ccf93d772a4bf13739bea4e01fe3f35733c4ec49d30911f"
    sha256 catalina:      "3493df2587bc90fe4263662a69aabc443d4fa654913c72e018ad6e5372d9c6c9"
    sha256 mojave:        "1766a5ee0533c67240a87b9a92563f63e740af741b66748aefda25088155c67f"
    sha256 x86_64_linux:  "9853e84cabb24febb116549ca1a2e0c965e9d1979aaccb7189a9e7f458da0217"
  end

  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "readline"

  uses_from_macos "libxml2"

  def install
    readline = Formula["readline"]
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --with-launchddaemonsdir=no
      --with-privsep-chroot=/var/empty
      --with-privsep-group=nogroup
      --with-privsep-user=nobody
      --with-readline
      --with-xml
      --without-snmp
      CPPFLAGS=-I#{readline.include}\ -DRONLY=1
      LDFLAGS=-L#{readline.lib}
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  def post_install
    (var/"run").mkpath
  end

  plist_options startup: true
  service do
    run opt_sbin/"lldpd"
    keep_alive true
  end
end
