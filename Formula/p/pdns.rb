class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-4.9.3.tar.bz2"
  sha256 "b2e67046a7b95825c35ddc9119ed6e2e853537a576d0c4ee9080bb5f0ad3e8d5"
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
    sha256 arm64_sequoia: "41bd873756e9cb31c6eb2c8608973c1bf4f97b6d2eaf53f1eea529785e5e35f0"
    sha256 arm64_sonoma:  "eb8750b8ef9397a6c03d31ea970a3866d60658a935f9d5faf0187637c14c8e9d"
    sha256 arm64_ventura: "20c3d03c0019f29be45645e59dd62067ccdb092a55368c16cfdfa6434052562a"
    sha256 sonoma:        "7ce4b0c0760418446b8ac2aed2a616cfc42010b056144d0eb5f43885020a2d9e"
    sha256 ventura:       "fae54199e647bc8f0cab39853df93fc54c120d60b49229e8806037b8c6870acb"
    sha256 x86_64_linux:  "79ac28fa1a8443237b4120f059d009eee485b6b6c47f1bc10e2320d55c9e9377"
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
