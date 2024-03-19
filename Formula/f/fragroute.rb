class Fragroute < Formula
  desc "Intercepts, modifies and rewrites egress traffic for a specified host"
  homepage "https://www.monkey.org/~dugsong/fragroute/"
  url "https://www.monkey.org/~dugsong/fragroute/fragroute-1.2.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.wiretapped.net/pub/security/packet-construction/fragroute-1.2.tar.gz"
  sha256 "6899a61ecacba3bb400a65b51b3c0f76d4e591dbf976fba0389434a29efc2003"
  license "BSD-3-Clause"
  revision 2

  livecheck do
    url :homepage
    regex(/href=.*?fragroute[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_sonoma:   "5e54c1e3b6e247a78a26be191c9919b3dde5ed5b9e8615f71706c008a934f9c9"
    sha256 cellar: :any, arm64_ventura:  "81e64dc3533f9469fbf91253816511df14307fe3260fbf3b4c3d2b0c2945adac"
    sha256 cellar: :any, arm64_monterey: "7a01636214817acbaffacc3eb4f5c38b5a44c3b63d0239e548c923cc22e17381"
    sha256               arm64_big_sur:  "35adad42ecbe16056a06708e7d0a3af1b9611aa3cfc1b1dc8cede40ee6f3f69d"
    sha256               sonoma:         "ffb78174b4cfdbdb6721e5e6bfe9fe76acdf412b34af9e6cf5eacb7d227f3c66"
    sha256               ventura:        "de37d085aa93a0213819b702ea9393705ada7dff78d1d02651ed56550cfe0c16"
    sha256               monterey:       "de505dc5218cbde66b8d8dc1538be12fa87ab717c35ea3002c3e8dd017c50fe1"
    sha256               big_sur:        "6d9bc388969f3798ca6ff4bc6e4cf5ecbc03f995b5f21268ae57fd49a69ec1c2"
    sha256               catalina:       "1427f299e84d0b1662a3492dc9c69cd46776265dc8b76488752b19eee1126ba6"
    sha256               mojave:         "2e4c49a602719693ed6a285aab60158a489d0f6592920b37a41e7ee933959ea6"
    sha256               x86_64_linux:   "8bb5693e0c2a0b3f5b0d10750d306b75fde72e4e7d9247c8e3717f95204aa534"
  end

  depends_on "libdnet"
  depends_on "libevent"

  uses_from_macos "libpcap"

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
    # pcaputil.h defines a "pcap_open()" helper function, but that name
    # conflicts with an unrelated function in newer versions of libpcap
    inreplace %w[pcaputil.h pcaputil.c tun-loop.c fragtest.c], /pcap_open\b/, "pcap_open_device_named"

    # libpcap has renamed the net directory to pcap.
    # Fix reported to author by email.
    inreplace "configure", "net/bpf.h", "pcap/bpf.h" unless OS.mac?

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
      --sysconfdir=#{etc}
      --with-libevent=#{Formula["libevent"].opt_prefix}
      --with-libdnet=#{Formula["libdnet"].opt_prefix}
    ]

    if OS.mac? && (!MacOS::CLT.installed? || MacOS.version != :sierra)
      args << "--with-libpcap=#{MacOS.sdk_path}/usr"
    elsif OS.linux?
      args << "--with-libpcap=#{Formula["libpcap"].opt_prefix}"
    end

    system "./configure", *args
    system "make", "install"
  end
end
