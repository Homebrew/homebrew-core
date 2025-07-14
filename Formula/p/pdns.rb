class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-4.9.7.tar.bz2"
  sha256 "782875d210de20cee9f22f33ffc59ef1cdc6693c30efcb21f3ce8bf528fb09d4"
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
    sha256 arm64_sequoia: "c8a59a4b0c31ef2738fd801b5e9560e09d1aaac79dd45bd706e09332c54bef18"
    sha256 arm64_sonoma:  "6b5ff34f26082e1066c718512c7f0b49857d769c3b20f1bc59e6771152878174"
    sha256 arm64_ventura: "eed2cfb31420ea5f1dc9990731601460a20152aa57b3c827516bfccd2e5ae71d"
    sha256 sonoma:        "4d368093d7c24e0d1f22301d1fd0935d948f4ee00a091c5597bdb87cabeac664"
    sha256 ventura:       "6d61dc002267dca7a98b2c583dea47a4845d050a12f751ef9e1799fc92876158"
    sha256 arm64_linux:   "4d7fdac3df230da367e436b7d3ffb397ebc1b35ca8b63fd3ffda798aa62e1871"
    sha256 x86_64_linux:  "7a5a6b2c4ce154932267aa5e64c878dbbff5f47e54008a6700dfb08de2729dcd"
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
