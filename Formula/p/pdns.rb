class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-5.1.5.tar.bz2"
  sha256 "7b670653ccd72be30d973bbdd349c4505beda1b87b842af702a341fa6837f8aa"
  license "GPL-2.0-or-later"

  # The first-party download page (https://www.powerdns.com/downloads) isn't
  # always updated for newer versions, so for now we have to check the
  # directory listing page where `stable` tarballs are found. We should switch
  # back to checking the download page if/when it is reliably updated with each
  # release, as it doesn't have to transfer nearly as much data.
  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "c385d0ed2b6da0f44ffc45367db9b899f414481b84d424e9e0e274701bd1f6d1"
    sha256 arm64_tahoe:       "4b17e943388f56745af563277fa3e8c320a486841e4c56a51d054e044c188ebb"
    sha256 arm64_sequoia:     "742cd475b8dcf9973c5f7f99c9749c4c67dc392d3f2156fb001c1c272ee82023"
    sha256 arm64_linux:       "ae9859aaa05e4c141c5be6bee748f962566082fd4c5a9437d31401a3f2f3aa38"
    sha256 x86_64_linux:      "bccbd0eb4311a012930f911bd380d44e7e1622ed1a14cef9691cdbaae62a2a1e"
  end

  head do
    url "https://github.com/powerdns/pdns.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
    depends_on "ragel"
  end

  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "lua"
  depends_on "openssl@4"
  depends_on "sqlite"

  uses_from_macos "curl"

  deny_network_access!

  def openssl = deps.map(&:name).find { |d| d.match?(/^openssl(@\d+(\.\d+)*)?$/) }

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}/powerdns
      --with-lua
      --with-libcrypto=#{formula_opt_prefix(openssl)}
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
    output = shell_output("#{sbin}/pdns_server --version 2>&1")
    assert_match "PowerDNS Authoritative Server #{version}", output
  end
end
