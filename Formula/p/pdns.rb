class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-5.1.3.tar.bz2"
  sha256 "5fb05d5e197f63ab667d9b905e69dc8293244a896fbd046b3630b223ea5051e6"
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
    sha256 arm64_tahoe:   "849ef3a5bb9817c3fb26c2c1a6ff7220de1807a5d44e335589d20c80c6421172"
    sha256 arm64_sequoia: "8250ceb243611a285dd5ee6a95097fe138714d53025cba49e6d49783e84b4886"
    sha256 arm64_sonoma:  "4016bd13d19174ec9b4ef347a1202d5be629ea787a0c23b9887801f69b126968"
    sha256 sonoma:        "1d57ee6528cb2de449e70007fe8cfc3d8ec139b74ace6818cb3b3e0e99f76727"
    sha256 arm64_linux:   "3b64e61d20479d6c523a03a2cc4caa5221d4cf3de39980c97d4ac9d4c76370a2"
    sha256 x86_64_linux:  "1b7f662f6e116230724a6cdbd518482eb1f617f34481daba831010a5c84b6343"
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
      --with-libcrypto=#{formula_opt_prefix("openssl@3")}
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
