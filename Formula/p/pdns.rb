class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-4.9.1.tar.bz2"
  sha256 "30d9671b8f084774dbcba20f5a53a3134d0822ab2edc3ef968da030e630dd09a"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://www.powerdns.com/downloads"
    regex(/href=.*?pdns[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "660e48a419366a19a97f2f05bd5abffdd16fc0e5ae0e1f29cc76923e8d98784a"
    sha256 arm64_ventura:  "1d36e9e6ffeba02de5e6bad5d320f9ad23f0e7bfc36cab5a1a7c6743a9f5300f"
    sha256 arm64_monterey: "8dbfe8340a87dc4306b88abeb60bcc2cf1eff2459c48adf5bd456d56df696963"
    sha256 sonoma:         "10e5ea6461ddddc7f7ecbdcf144566ca7466468d6f8fbd027f45e4625dfaeccf"
    sha256 ventura:        "20dfdf4113f1804649620d1ae313d62a497cc5ca91b1f353bd69480113da9bdb"
    sha256 monterey:       "ee59a163a5150373a16dde3346072919c542ac040451ac9d78ad179e41611323"
    sha256 x86_64_linux:   "391591c9b46eb4e441496ca6923e04529a137ab3734537cede69ac29f26b1c65"
  end

  head do
    url "https://github.com/powerdns/pdns.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
    depends_on "ragel"
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "lua"
  depends_on "openssl@3"
  depends_on "sqlite"

  uses_from_macos "curl"

  fails_with gcc: "5" # for C++17

  # Fix build with boost 1.86.0. Remove if PR is merged and in a release.
  # PR ref: https://github.com/PowerDNS/pdns/pull/14562
  patch do
    url "https://github.com/PowerDNS/pdns/commit/eed56000b1d68ac083b8e8bea4ff0ea30a1579c4.patch?full_index=1"
    sha256 "c21a8677c048f3ce023f2e09c5204602031a78c441904567a4da2b7870dc29ad"
  end

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
