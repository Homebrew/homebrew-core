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
    sha256 arm64_sequoia: "8ac0677fcf305e7d82882bf52287abacc7060e57820303d26d9c2a5c7fa52cb5"
    sha256 arm64_sonoma:  "d3bb37b574b2b59b00957e0fa77753f04d1e25d73e4a8e91ba3b29aadf517db4"
    sha256 arm64_ventura: "265d162d41cefcf0ed6db36d1a34cc819fe2238226ba117f6ab634321c76f59c"
    sha256 sonoma:        "752004f2e6c29770dc8fb5a802f099025e8ec6ab7db044249fb616ac94c13091"
    sha256 ventura:       "b1b68d140946281177c242f5cc6ba7eef52d6218bf70ac7dcd58d7601718f725"
    sha256 arm64_linux:   "5f0996791957179f409054cf8c3b5fd3be0b16600c553992a19099f28c00fe3a"
    sha256 x86_64_linux:  "93a5f5858a20122977141b31485e73eeb5f810d67a24fc86c5911df5c83c1d54"
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
