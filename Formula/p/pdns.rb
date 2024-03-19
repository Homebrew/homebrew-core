class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-4.9.0.tar.bz2"
  sha256 "fe1d5433c88446ed70d931605c6ec377da99839c4e151b90b71aa211bd6eea92"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "b46d44881fcf1a830f3c883a1fc764b5e985c82633ab188ba3fdee961db20028"
    sha256 arm64_ventura:  "116f9566bcca9232acd03cd6ff32749b63f02314708cd2a87fdd86debf45950b"
    sha256 arm64_monterey: "c15ee8377e2848e7d8ad7bbaed8eb93f0c4f6c31120a01984c0fede96efcea4c"
    sha256 sonoma:         "5fa0158f807bf73512b4dbc140ce5b45daafddc076cabdcc25f9e32cfdaf0b9b"
    sha256 ventura:        "6a1056a3e8310b86cbe1ac643cf382599db1c5ba8593e5a881f386b96a463f76"
    sha256 monterey:       "86504e3ab78e68aedcb2dda68834b178a7a5e27f05c92f7e94e5844a6c05316a"
    sha256 x86_64_linux:   "46eddab0ef267edd5a1584d7d629b8ccb5460b9094a09f260100a89058c88f78"
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
