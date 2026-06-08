class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-5.1.1.tar.bz2"
  sha256 "08937955ce444bbb0aabfdf6a5f18d483dd5893d761539811be17a9b6cf33b6a"
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
    sha256 arm64_tahoe:   "9e07d4946755fe1aec08017541d9c9354d270b2053eaf59bd56df2c70353d78b"
    sha256 arm64_sequoia: "b93470f0e613c73d09c6dfd7a1cf7dd4d6b0c13f68cda16eb4b2e87da945f2de"
    sha256 arm64_sonoma:  "068349d3191310e9e448a85d9cc8db3a919b5f50de94770aeb9b712cf34b668d"
    sha256 sonoma:        "c4a1c6af94147b6561d0b695a935f85e01d49d6213fd5071d7055ed5542b41de"
    sha256 arm64_linux:   "cc28d1b05602158b70e0e0db41418bece5bd195956cbdd416a224bedbe7006f8"
    sha256 x86_64_linux:  "3c759ecb7a984fd7e8112785bfafbe7ee7d4870ae73ae0724aa0cc9b7dd13abe"
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
