class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-4.9.2.tar.bz2"
  sha256 "f570640427041f4c5c5470d16eff951a7038c353ddc461b2750290ce99b2e3c2"
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
    sha256 arm64_sequoia: "535cd7e7c65f70335ddf11a9b3987763d8c0ad95f27da2fa2bbefb3f7f609aad"
    sha256 arm64_sonoma:  "8373819cddbb5ad653d70ad4b0d69f36faa074d6b46a5f70a6922311da8069d3"
    sha256 arm64_ventura: "77b98a0f0c9638c1f593c30ccf792f11d9efc016001b96b31cbac5ff651135fd"
    sha256 sonoma:        "a0a4db1bfd7e8ba3ec006bbcf750bb1da15573a4a6a2b54bd9427e4c6e9d05c1"
    sha256 ventura:       "eec08612848bb1ee690b09ee227ddbe697c47ea9477d9aa938da251a408df04a"
    sha256 x86_64_linux:  "e00dcb42455de9c473ebef4478be1796594b2da80f7a3cbc77feeb5bb417d12a"
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
