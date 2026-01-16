class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-5.0.2.tar.bz2"
  sha256 "d360e1fa127a562a4ad0ff648aef56af76b678311c6553a7f7034677438a085d"
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
    sha256 arm64_tahoe:   "5457efb6d970ccadd256d6a942896d39ea92f40b18f372fa4ede4712ba60ab8b"
    sha256 arm64_sequoia: "bd92b514f48721377cb0834335d19f5b2e3ac75102a34d0590ebd4d9547a3036"
    sha256 arm64_sonoma:  "988a657fed691bcd263648a385c1934d160365d0b821f2893d72056ba70b1d5d"
    sha256 sonoma:        "8216953ffcea05a821632fd9bbd0205a2a14f04905245325536e56b5336f3155"
    sha256 arm64_linux:   "df5588e192dbedb416cc203ef9dadd83ff2c240fbe145822fc513d2930de6d9c"
    sha256 x86_64_linux:  "76911b9bb4ac3d41795fce0c1f983743de99835cca64bc5a1cdc2be919cf2364"
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
