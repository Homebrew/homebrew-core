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
    sha256 arm64_tahoe:   "16c4cc9d15565389da8e5122fbba6ef4f8d7591beee8e2286798e2b95e41cf21"
    sha256 arm64_sequoia: "23ed75639e0796d6d3f5b06ffa07924f0d5c5e5e1245356aa137026243637f1f"
    sha256 arm64_sonoma:  "7a5b82f8c054b02fe360f272b553f2707a6fc20bd6cb3148f34898c418ec9eb4"
    sha256 sonoma:        "32ff181e617c34ec69c85aa234087f152f9887d44d39645ddf6d8fd2b117434f"
    sha256 arm64_linux:   "8a8a696c31eb5b54a7b850344a34cce1a4e62a05ec118f3b24cffad9bc278806"
    sha256 x86_64_linux:  "81384bff1af4e5661a04f6f57fa5999a03a113b240b86283570c9ece070d89c3"
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
