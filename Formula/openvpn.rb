class Openvpn < Formula
  desc "SSL/TLS VPN implementing OSI layer 2 or 3 secure network extension"
  homepage "https://openvpn.net/community/"
  url "https://swupdate.openvpn.org/community/releases/openvpn-2.6.1.tar.gz"
  mirror "https://build.openvpn.net/downloads/releases/openvpn-2.6.1.tar.gz"
  sha256 "8cbc4fd8ce27b85107b449833c3b30fb05f1ca3c81b46a0ba8658036944266bc"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://openvpn.net/community-downloads/"
    regex(/href=.*?openvpn[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "90e8b15b5b20dfad593ff5f5746dc173b109b80deb4e9dbf650bd16844c773e6"
    sha256 arm64_monterey: "b62a0185ce3555a53c54809b30b152009c93084ee6351025bd118f9b52925967"
    sha256 arm64_big_sur:  "4f53c925ea33d5910d39a59652060e318d15f3294c5cf0ebe2044de0c9113a85"
    sha256 ventura:        "1e75170ba24ca9da2ab930d2af8049755b5e8b55bc2ed76e25feb9bf5c028570"
    sha256 monterey:       "1154004d0cd5e657648ff9adb07184c56930a4368bc56e7dd9e322768ca388a3"
    sha256 big_sur:        "1b07207a0d080f6405172b124e5560d6154f3759c43454d8027cf7788cbc5749"
    sha256 x86_64_linux:   "a1e9c9ed3fa8cf3e2b8e37ce19d84abfeb9d48565cccce791ebca30aef648aa6"
  end

  depends_on "pkg-config" => :build
  depends_on "lz4"
  depends_on "lzo"
  depends_on "openssl@1.1"
  depends_on "pkcs11-helper"

  on_linux do
    depends_on "libcap-ng"
    depends_on "libnl"
    depends_on "linux-pam"
    depends_on "net-tools"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-crypto-library=openssl",
                          "--enable-pkcs11",
                          "--prefix=#{prefix}"
    inreplace "sample/sample-plugins/Makefile" do |s|
      if OS.mac?
        s.gsub! Superenv.shims_path/"pkg-config", Formula["pkg-config"].opt_bin/"pkg-config"
      else
        s.gsub! Superenv.shims_path/"ld", "ld"
      end
    end
    system "make", "install"

    inreplace "sample/sample-config-files/openvpn-startup.sh",
              "/etc/openvpn", etc/"openvpn"

    (doc/"samples").install Dir["sample/sample-*"]
    (etc/"openvpn").install doc/"samples/sample-config-files/client.conf"
    (etc/"openvpn").install doc/"samples/sample-config-files/server.conf"

    # We don't use mbedtls, so this file is unnecessary & somewhat confusing.
    rm doc/"README.mbedtls"
  end

  def post_install
    (var/"run/openvpn").mkpath
  end

  service do
    run [opt_sbin/"openvpn", "--config", etc/"openvpn/openvpn.conf"]
    keep_alive true
    require_root true
    working_dir etc/"openvpn"
  end

  test do
    system sbin/"openvpn", "--show-ciphers"
  end
end
