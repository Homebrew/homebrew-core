class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-5.0.3.tar.bz2"
  sha256 "ec3120501950a772c785c600f599e8f4d711f703a02cbd1bec42edc1a05f81cc"
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
    sha256 arm64_tahoe:   "c02252c3db32285b1064a57196868f9642328f4c3652e5cc227a9e6cc8877363"
    sha256 arm64_sequoia: "31864a450be149033007265fa1efcd2506efc80f6a69725bc47978b2dbec35e6"
    sha256 arm64_sonoma:  "8b3824e0c9af605ff3eee856b722165d42aa3a084868e35171546c3f96d35670"
    sha256 sonoma:        "0889f0d18d424d65b269e0f3e752dbc174db3203af450c84b6734cb0c0ac3aba"
    sha256 arm64_linux:   "73f5fdc2c1da5b7ce0d3f3871b792192cabbe650f707161b49d8b7a2794238a1"
    sha256 x86_64_linux:  "eaee7c1c455c7af9875303d0e990cef8de6e0ceaac9c35a2d597a848fbf0bd7a"
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
