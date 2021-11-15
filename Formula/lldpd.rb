class Lldpd < Formula
  desc "Implementation of IEEE 802.1ab (LLDP)"
  homepage "https://lldpd.github.io/"
  url "https://media.luffy.cx/files/lldpd/lldpd-1.0.13.tar.gz"
  sha256 "d639827fd8a27720d1bfd94bc52eca24af63ddcc3c9d2da60788778889d84701"
  license "ISC"

  livecheck do
    url "https://github.com/lldpd/lldpd.git"
  end

  bottle do
    sha256 arm64_monterey: "95fd094817acf4cf94f42e5e80c30d3dd397a6e7529ea4ac286c6434ec7e16be"
    sha256 arm64_big_sur:  "d9d390a4404acff3d2d13a9dbdbd412833534f33447f6e0ec0283917abc6b261"
    sha256 monterey:       "3817d0b551c350cec5db423aaa6cf05901ea5dd9a417d71692c9bc25c183c337"
    sha256 big_sur:        "4c2dba23fc7245e3b5988feedfe59032f7eed33dc248cbfdc70d0bb300afd035"
    sha256 catalina:       "20caa1840ab87f99001b351c9d7aea2bb876880970c437eca9850c7a6e9bcf5d"
    sha256 x86_64_linux:   "380bb78d5ab7308637e07d68ea60018f75af59c172f5fdf8b21e6f0f82c958fa"
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
