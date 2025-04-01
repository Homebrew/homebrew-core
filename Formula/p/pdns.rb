class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-4.9.4.tar.bz2"
  sha256 "cac466d7cb056434c60632e554be50543cb0cecd9d3b33bb5785c149b5979fc1"
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
    sha256 arm64_sequoia: "120cba37eb991972c895ba744fc9e1bd57ed95d464d4e15e5fdb8b6448b2cfeb"
    sha256 arm64_sonoma:  "b6b0caa6958bdfc8fcca13f5f2dea9d8fe27e8bea1297592e20b24dde12c3d5d"
    sha256 arm64_ventura: "95850895c3075b4e8c95bae6177f38d30807874586fbbd027083bbc4760d5172"
    sha256 sonoma:        "26559eb2c7b5ed81996c53885718f37361b92ca42d32220109af5a3a339535cc"
    sha256 ventura:       "2020e1497bdea7babd1db4df8307da32a971337b1b483c0d7b05a60a6f366a30"
    sha256 arm64_linux:   "15d314826ac0d3d92d4071cbbbb67243e15854a35885802964c36e362139141d"
    sha256 x86_64_linux:  "d1009fdc037db87888ba8e81caca5f4b4698f7799c57dc9e289b3eb195be4420"
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
