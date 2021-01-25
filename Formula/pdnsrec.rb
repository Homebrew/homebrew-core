class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  url "https://downloads.powerdns.com/releases/pdns-recursor-4.4.2.tar.bz2"
  sha256 "b0b97f49848a1758b64bc0b99a596c1583ea525477193f3c01905f5163a4f5cf"
  license "GPL-2.0-only"

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 "09aedfb6fae88ddc911022c9f2d8166e3746d401a9d54fe3742bc117831beff1" => :big_sur
    sha256 "a6aa0796a7d756013f091d557864091220ca773ee298c609b344a7288408dcf7" => :arm64_big_sur
    sha256 "5d78e21c1882b3bdf96317c7044a8f247f0601f33ba9dcb074be05ac9d9c7475" => :catalina
    sha256 "1ebddc007e37972ec7703a6c422dcc81991fd721c32a3ae07d4117ba34faf6a6" => :mojave
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "lua"
  depends_on "openssl@1.1"

  def install
    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}/powerdns
      --disable-silent-rules
      --with-boost=#{Formula["boost"].opt_prefix}
      --with-libcrypto=#{Formula["openssl@1.1"].opt_prefix}
      --with-lua
      --without-net-snmp
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    output = shell_output("#{sbin}/pdns_recursor --version 2>&1")
    assert_match "PowerDNS Recursor #{version}", output
  end
end
