class Fragroute < Formula
  desc "Intercepts, modifies and rewrites egress traffic for a specified host"
  homepage "https://www.monkey.org/~dugsong/fragroute/"
  url "https://www.monkey.org/~dugsong/fragroute/fragroute-1.2.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.wiretapped.net/pub/security/packet-construction/fragroute-1.2.tar.gz"
  sha256 "6899a61ecacba3bb400a65b51b3c0f76d4e591dbf976fba0389434a29efc2003"
  revision 1

  bottle do
    sha256 "79fcf3e14e1efa3a35fe8c0107ceb3830f4a7c4d6ea33b183b70530ba2e0b0e5" => :mojave
    sha256 "65ea82f265aeb3018b59f1c24630ad2e88fc8d3c678579f4e83be4f339005450" => :high_sierra
    sha256 "54e5062ef504ba660fa5bbc67a562c7fd9a80fbca511cf37c10ca65d135cefe7" => :sierra
    sha256 "d9a4634cf2e7759caed69fee95f5f0044e4365cbaaf308a2f5abddfa46f4bec1" => :el_capitan
    sha256 "7c1fc2c4a43e91a22b2e999d071424c5b57243820e2293cc4106e4b68ded0323" => :yosemite
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
