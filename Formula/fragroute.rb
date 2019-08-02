class Fragroute < Formula
  desc "Intercepts, modifies and rewrites egress traffic for a specified host"
  homepage "https://www.monkey.org/~dugsong/fragroute/"
  url "https://www.monkey.org/~dugsong/fragroute/fragroute-1.2.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.wiretapped.net/pub/security/packet-construction/fragroute-1.2.tar.gz"
  sha256 "6899a61ecacba3bb400a65b51b3c0f76d4e591dbf976fba0389434a29efc2003"
  revision 2

  bottle do
    rebuild 1
    sha256 "d75cd70289425f638b6d3ad95d036d2afd2a504f27edf2d45ee221b4a1f027e8" => :mojave
    sha256 "a52b1134ffa977cfbf33a07996dd75ff596a3a46a8b5f4b368c2a1d25a9ac779" => :high_sierra
    sha256 "a98a1d9477394a5f06f8c1b91f0e90ef0a1cb53cd09263ba332928e032012e63" => :sierra
  end

  depends_on "libdnet"
  depends_on "libevent"

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/2f5cab626/fragroute/configure.patch"
    sha256 "215e21d92304e47239697945963c61445f961762aea38afec202e4dce4487557"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/2f5cab626/fragroute/fragroute.c.patch"
    sha256 "f4475dbe396ab873dcd78e3697db9d29315dcc4147fdbb22acb6391c0de011eb"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/2f5cab626/fragroute/pcaputil.c.patch"
    sha256 "c1036f61736289d3e9b9328fcb723dbe609453e5f2aab4875768068faade0391"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
      --sysconfdir=#{etc}
      --with-libevent=#{Formula["libevent"].opt_prefix}
      --with-libdnet=#{Formula["libdnet"].opt_prefix}
    ]

    args << "--with-libpcap=#{MacOS.sdk_path}/usr" unless MacOS::CLT.installed? && MacOS.version == :sierra

    system "./configure", *args
    system "make", "install"
  end
end
