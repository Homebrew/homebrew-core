class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-4.7.3.tar.bz2"
  sha256 "8bad351b2e09426f6d4fb0346881a5155fe555497c3d85071e531e7c7afe3e76"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "f296a4ce2268379b0b976e2362701123054e6dc77668cfb8290d5b377824709f"
    sha256 arm64_monterey: "a10e3f0382db16369e12efcc28686a58a954dbe915ffed71c62f0634df7fa343"
    sha256 arm64_big_sur:  "aa4996dd49f264094be930ab9816f9a3c5bfeb6dd629a7864d5f8d3c50d776f7"
    sha256 ventura:        "cc64ef4d5267f92b5f1b3a331d5c93823df38e6022ac8b5cb87088d695fc98d9"
    sha256 monterey:       "dd6e300214a5d6f8651f0c949e66db3fb3069b6c8f9d0e746f934338fa2f43eb"
    sha256 big_sur:        "69e2848ad8c674cb42343dd52c04027a549aa8646b5ac1bd0ffff8b0187115d9"
    sha256 x86_64_linux:   "2f933e6faf5412c9225e64a103ea3c3f11548746911dcd59dd7f857ec9bc4cdd"
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
  depends_on "openssl@1.1"
  depends_on "sqlite"

  uses_from_macos "curl"

  fails_with gcc: "5" # for C++17

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}/powerdns
      --with-lua
      --with-libcrypto=#{Formula["openssl@1.1"].opt_prefix}
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
    output = shell_output("#{sbin}/pdns_server --version 2>&1", 99)
    assert_match "PowerDNS Authoritative Server #{version}", output
  end
end
