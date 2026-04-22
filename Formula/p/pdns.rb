class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-5.0.4.tar.bz2"
  sha256 "36e96d929999efc88bcb734f94dc45f8e292d1040ced0891e664bd0a8edf9d0e"
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
    sha256 arm64_tahoe:   "b9194aa7d94dce35e33afb2f97f750fa7ccab70eca2ebbcad25e9f91c299766c"
    sha256 arm64_sequoia: "0ce5c41c31e1bc2b65c73ede43a3206ab1d4663173c10c79d7569836e42830f3"
    sha256 arm64_sonoma:  "4f84698bc26aafa37357db9f9816026e2e441ef9b3f91fe34856c8483a3ba8d8"
    sha256 sonoma:        "e66299b1e91793d36b4b32c9f17c5cdece38a422324e27665f54c84796a05555"
    sha256 arm64_linux:   "d0fada533f2b5bf030fb646921f767f24c20c9a679162c79f24ea89eb01d8fd0"
    sha256 x86_64_linux:  "207f5111cbb5a79a4e041007186c82b61f4e61c4b83e6ee0fe3c7e8acaec7929"
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
