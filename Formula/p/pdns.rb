class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-5.1.7.tar.bz2"
  sha256 "70cb249cebf982285d44c41704ad1524d3739d59de0534832c576f95a75953a6"
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
    manifest_sha256 "4797f03365a071922b521e144a3a409e922a5a66d8b9a0388546abaa448f1da9"
    sha256 arm64_golden_gate: "cfb9ab37ad45fb68e9f51bee0600355d66fc396d080f26e0274a0bb10a98f94e"
    sha256 arm64_tahoe:       "9368ec2196a18a91552b06a2c11f2c2d083035ef6ee3a73b670467b003a51ef5"
    sha256 arm64_sequoia:     "58d7ca17c2a5284e094be603ea20f0755f9334377583877035919b558e029663"
    sha256 arm64_linux:       "61c0241e29d70b1b0b8338ce8b3f31c7735cc92a92dd7222128d51d940703b6d"
    sha256 x86_64_linux:      "82da5bf8a40b0ecac5b14824a7774f1195dac57b70607aef5f01e21c72826873"
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

  def install
    openssl_prefix = dep("openssl").opt_prefix
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}/powerdns
      --with-lua
      --with-libcrypto=#{openssl_prefix}
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
