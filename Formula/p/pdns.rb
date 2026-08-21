class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-5.1.4.tar.bz2"
  sha256 "f8a10edbf60e49d8c160e93121989d5ebcdad838d0e0b747f26ef7e89fd220c0"
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
    sha256 arm64_tahoe:   "f9ae01cc72b5d6cc59ce65aba5838f5846fcb5e1f92d4835a805b5201ef5902e"
    sha256 arm64_sequoia: "5b028a81bf981f1863681236aef0eda607ce833407e5f4068197bf444231b19a"
    sha256 arm64_sonoma:  "5d1a24e7b7f12d6f5a5890a7a5b04e9aea362c44244213a9e53815213c0e7719"
    sha256 sonoma:        "b5033532473e8380f77827e166a378be6d0b395549e36ce39499d91b580c1281"
    sha256 arm64_linux:   "fa7210190354446861777a132462235040d75859a466cef7c6945a18f511abbc"
    sha256 x86_64_linux:  "2f0c18cac62b4c6e8e9207e175d39525589557cec16e7b5510c72d8232682ed6"
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
