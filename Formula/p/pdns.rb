class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-5.0.0.tar.bz2"
  sha256 "0dcce355d97a99acefc1d45d63c117d952149867dc7983236f7efc9e041b0a30"
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
    sha256 arm64_tahoe:   "a6c89aecaa71666af56164a7ca46b71ef4890c32044b4fedb9f7cbe8b7be7d4b"
    sha256 arm64_sequoia: "578c48786f3e8f4ab14fe41a6a3facafd68bd2790ef05ac211f36551341c0952"
    sha256 arm64_sonoma:  "f18c07d3977de22ad500f89799ae1cdb8413a61f54b5e460fac3ec875e580548"
    sha256 arm64_ventura: "d837445f157d34d299f783816b01499e39f2f50a65a706e1338fababc861019f"
    sha256 sonoma:        "c70eeac3864e7a1df6ad59ca9ec5ee407f2d878157e68ae4dbf50695c0cb2432"
    sha256 ventura:       "81c03561c373d96a8f61f4ff158a5e64966bf1b6387c7e028d284f600022531b"
    sha256 arm64_linux:   "6d04b60294d71f140f8466fb487525bb6931e0357f06b35717428830235e04a1"
    sha256 x86_64_linux:  "d7125aa2483e31aac0080a1c5c5561340a5445d8105d7fadf02b2103b34720ab"
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
