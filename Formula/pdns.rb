class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-4.6.0.tar.bz2"
  sha256 "b9effb7968a7badbb91eea431c73346482a67592684d84660edd8b7528cc1325"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "689b5b7873869c5cb3b1fac746552f7b77e2294b8a63b708b52bc04a3de0eee5"
    sha256 arm64_big_sur:  "9bf2eab288fb7ffa0f9b625110a88b71249d513f0e7462814dbcfb619f762a71"
    sha256 monterey:       "69c257f5b8da96ffd5cd8be410db4c4cab4121895c6add4aa18b0bdf2b4ca239"
    sha256 big_sur:        "1348e019298751d9eff1e233ec3a4542a9aa075b290a466d31818458ee94d3b6"
    sha256 catalina:       "88b5bd486cc787675be0dd85a99e4b0ff20ba6e0471d47317bacce3860759595"
    sha256 x86_64_linux:   "a752a23dd132efb7b5ddf85175dd9cd71452a443dc7ebfb4140f919f0d8d059f"
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
