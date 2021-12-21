class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-4.5.2.tar.bz2"
  sha256 "93d94a2500b1b3288dde0e76da7c40095382d93f0998d0f15449d1e6fc033641"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "aee6620ec75691f52847aeae7e41a5245801b1c2bda56071c51f9c8cc0778b0a"
    sha256 arm64_big_sur:  "0938f5acdf256c636a0b0a432e46f4038db29cc301d297864e677f607a4d6118"
    sha256 monterey:       "d451672f170e1e26279258069004668d8e81c75047ee0e061815334c3511162e"
    sha256 big_sur:        "1c9ad24b87edac72a2f1833f79063c70dab768722a61a58485ed1985a90b25cd"
    sha256 catalina:       "933208e353c7ef908a6ada9464b5a8dc5dce3d6a7455ef8bafd892f6b45f80e3"
    sha256 x86_64_linux:   "af45246ab6ec2d5a516d8463bee88a991f7168365e795c016441110bdfe4bc8b"
  end

  head do
    url "https://github.com/powerdns/pdns.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
    depends_on "ragel"
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "lua"
  depends_on "openssl@1.1"
  depends_on "sqlite"

  uses_from_macos "curl"

  on_linux do
    depends_on "gcc" # for C++17
  end

  fails_with gcc: "5"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}/powerdns
      --with-lua
      --with-libcrypto=#{Formula["openssl@1.1"].opt_prefix}
      --with-sqlite3
      --with-modules=gsqlite3
    ]

    system "./bootstrap" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  service do
    run opt_sbin/"pdns_server"
    keep_alive true
  end

  test do
    output = shell_output("#{sbin}/pdns_server --version 2>&1", 99)
    assert_match "PowerDNS Authoritative Server #{version}", output
  end
end
