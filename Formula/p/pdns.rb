class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-5.1.4.tar.bz2"
  sha256 "f8a10edbf60e49d8c160e93121989d5ebcdad838d0e0b747f26ef7e89fd220c0"
  license "GPL-2.0-or-later"
  revision 2

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
    sha256 arm64_golden_gate: "3f392cbd76db562bd68583c3ade8f58a3d74c10e1edfd37b9a71216942d4fb24"
    sha256 arm64_tahoe:       "d7102fd99834a7b2585dd8e79ba7bd452349d4e177a34712216b4263193f3359"
    sha256 arm64_sequoia:     "ed7507d7db6bff569d3e593ce1db5267f02ea4806f8fc1a4ae3dbd0ed5feb3a8"
    sha256 arm64_linux:       "b274729ba5d613e72194b0d53087b56513118a5cb9468abcb94e35dd1baad417"
    sha256 x86_64_linux:      "d75df0d2832314c396b48014b2f92539f7377261112a317df3ef45cbcbecbfa2"
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
  depends_on "openssl@4"
  depends_on "sqlite"

  uses_from_macos "curl"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}/powerdns
      --with-lua
      --with-libcrypto=#{formula_opt_prefix("openssl@4")}
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
