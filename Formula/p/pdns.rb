class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-4.9.5.tar.bz2"
  sha256 "669bb7b99823b32c3901337d69b38c9f8073f2fc02e8764933b8c5c0974e2724"
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
    sha256 arm64_sequoia: "fb8632a4bed8ad090c89ec5f1f45f80258173583e2d94f874a51ffe3872c57e4"
    sha256 arm64_sonoma:  "020265542e8be2ca67232914147fa9777fee495c0959902d7119170d7e3b20c3"
    sha256 arm64_ventura: "70fde4ca2ab25d973dcf35597ec31c3048e7a69703f148b096c323d699a92335"
    sha256 sonoma:        "e95ffc9d3a7c07239dad247fdcaaed963377601bde673fd31848f336d1d05569"
    sha256 ventura:       "cae7d9a935325d132ca86e49d311df8adc4215ed8ecbd0137170b8b0d8643dbb"
    sha256 arm64_linux:   "04b8ead3952463b591b9045f73a0adb843d8f7d234cb8b98f28cc83ca668025a"
    sha256 x86_64_linux:  "1de0c061b0be4150cda9313024254850c4b20359fc2fd0c4ec866ffe0b872bdb"
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
