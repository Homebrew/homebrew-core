class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-4.9.8.tar.bz2"
  sha256 "180b66ae332d3166968e013bff7cbf6f0c72869d6be697db74a02df3ac6e8a91"
  license "GPL-2.0-or-later"
  revision 1

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
    sha256 arm64_sequoia: "21e9b39763d4277dbe3961b026aac1bffddd43489197145e21cbc38c8947a8b1"
    sha256 arm64_sonoma:  "18f8ad68ec4743b02218559cdf7974c87d413006e408f1315217fcc0a08ac940"
    sha256 arm64_ventura: "61c35194e43c36bf2ced9745df429319026eba1b29f597ad56cfff6d24e4437c"
    sha256 sonoma:        "90a5379bd6ee68200b30b76bf88a574293ad6a47276cc4dd4b90508f4a7b76b4"
    sha256 ventura:       "6aa8b35451056eaa6803273bf552c50b34bd9620c058f4e3e154dad99f19598d"
    sha256 arm64_linux:   "9585c08f645caaafe799249cc6b6085e3fb9bba0b7118dcec095dc9564e9e840"
    sha256 x86_64_linux:  "b9f3ccf5be398591637a1a0e5bbc063f4ce5ff0718a73493e1de249372fd5f0e"
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
  depends_on "openssl@3"
  depends_on "sqlite"

  uses_from_macos "curl"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}/powerdns
      --with-lua
      --with-libcrypto=#{Formula["openssl@3"].opt_prefix}
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
