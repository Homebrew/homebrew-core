class Lldpd < Formula
  desc "Implementation of IEEE 802.1ab (LLDP)"
  homepage "https://lldpd.github.io/"
  url "https://media.luffy.cx/files/lldpd/lldpd-1.0.20.tar.gz"
  sha256 "61b8cb22d4879e68f7825a2fb8e1e92abb4aba4773977cf0258bc32ed9f55450"
  license "ISC"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?lldpd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "3a1fd2fbde828febd4d1a20f1fcf108d3260f738d8aa7d61afd8fd2fe1a3f3e2"
    sha256 arm64_sequoia: "c1643a1a0d221554cc15ca97adecdfa9580cb7e36e817007f226cfac7c029f4d"
    sha256 arm64_sonoma:  "8bcb0d4e3ad57fb2fb62820ae0fab4623ea6b3d3bbf67e3ea3429b958c4dfa2d"
    sha256 sonoma:        "4fa0829af9f78f062a5e761b5bd3c305bda531ec1874f0aec1a5eef77eb09f55"
    sha256 arm64_linux:   "50bd4e8221cd0ce4cc3bc580e50b1573b70afd7c44f20b6c94aaee94578731ad"
    sha256 x86_64_linux:  "ebadd50322c524f0ecfaafb505be2668d7e2c41d91aa6df874b7457fa8c26d15"
  end

  depends_on "pkgconf" => :build
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

  service do
    run opt_sbin/"lldpd"
    keep_alive true
    require_root true
  end
end
