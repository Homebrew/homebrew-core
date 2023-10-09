class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-4.8.3.tar.bz2"
  sha256 "77b91199bdf71874334501c67e26469c2667a373d8423803fe657417295c77ba"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "a53a7d0b5ce4b77d7d1432216db96d6c986e7154503a98b6a3e6cd3fab4fccaf"
    sha256 arm64_ventura:  "70194b85c7888603c8e9259183064f08184b5edc0ba56cc5bfbb72bbd67f8cb6"
    sha256 arm64_monterey: "7ca5ec69e7ea6fca29b20717b1cad845f06157b96f820c812e0684ad7dde252f"
    sha256 sonoma:         "4287fe8f9e38cfc694e822b115facb9e5c64554c201770f93437b6a8c502778f"
    sha256 ventura:        "b0c5e60561d3d05fecc572dc94e25ea757b026543a042af24d7fff03e2dd9453"
    sha256 monterey:       "219813979a6461adbfdea144f9ed5c77301ccc264bd08d2d61962818f2182692"
    sha256 x86_64_linux:   "8d05095fa30da45dd225464c7000f284baadbab01aa12949a129f76229b5df20"
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
    output = shell_output("#{sbin}/pdns_server --version 2>&1", 99)
    assert_match "PowerDNS Authoritative Server #{version}", output
  end
end
