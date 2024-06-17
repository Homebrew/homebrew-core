class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-4.9.1.tar.bz2"
  sha256 "30d9671b8f084774dbcba20f5a53a3134d0822ab2edc3ef968da030e630dd09a"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.powerdns.com/downloads"
    regex(/href=.*?pdns[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "45cfb0e6bc9a4daf32a9f47162828dbfc922b21573329aa5030136af7c4458a2"
    sha256 arm64_ventura:  "484eb8d3ca30e64ebae9e35f75a5567d2d60ee8320e26ea629c41bc5ff3ace9b"
    sha256 arm64_monterey: "38111355e0f36392af2c24210258efb0c2ccc490672851d6730a606c657c0119"
    sha256 sonoma:         "30a1f72a75c1b488def00e3c4a521c3252d7434b8a1c14b36a785c4ac4f6625c"
    sha256 ventura:        "ab99793a9aedf11f94cb8b599eba4b87f51f2d04d2a89a79dc64af71eaa3942c"
    sha256 monterey:       "430d61369186264de83ee350b08ac26108098c40a3dc17d356cc7d57c94438c2"
    sha256 x86_64_linux:   "a7f9c6ac172c712c7a7212b816efbad67e80bab0ebd37e1271050a04e937d4b2"
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
