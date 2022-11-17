class Openvpn < Formula
  desc "SSL/TLS VPN implementing OSI layer 2 or 3 secure network extension"
  homepage "https://openvpn.net/community/"
  url "https://swupdate.openvpn.org/community/releases/openvpn-2.5.8.tar.gz"
  mirror "https://build.openvpn.net/downloads/releases/openvpn-2.5.8.tar.gz"
  sha256 "a6f315b7231d44527e65901ff646f87d7f07862c87f33531daa109fb48c53db2"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://openvpn.net/community-downloads/"
    regex(/href=.*?openvpn[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "4f2544e764b896e1fac71c24a39be2b911f72919d1125e8883ab037ba7a3626a"
    sha256 arm64_monterey: "1d4263d9cb64238bcc4dd189ee6eecc7ef1547a9fd46628129543e8b93fb5e5c"
    sha256 arm64_big_sur:  "5a85f1cec155218f5b6aa2ab74b97b2179f1fa64c1c6a06bfa8baa7480c8f54c"
    sha256 ventura:        "12af78a89f2dddf79c3d69afec98afd0e849afb8a549cf35908de2a5d4ad5ee6"
    sha256 monterey:       "e10b34a0797f4a89ebdba699dbb178ea19fe38ed795ce5486b3cf1c20799d21f"
    sha256 big_sur:        "8942cd092a235d4e1d8ce1e4a163d4e2797ecd65eb9853146bd128bd39a1ba49"
    sha256 catalina:       "f765034a9b7e83206112d255ddf7c632eaea48105ef106724a331c930c301d5e"
    sha256 x86_64_linux:   "57427c5e6e331f100dd30ecbc1f8fc6d54d3ee84b2c22b45681ea6b0ea95edd3"
  end

  depends_on "pkg-config" => :build
  depends_on "lz4"
  depends_on "lzo"
  depends_on "openssl@1.1"
  depends_on "pkcs11-helper"

  on_linux do
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

  plist_options startup: true
  service do
    run [opt_sbin/"openvpn", "--config", etc/"openvpn/openvpn.conf"]
    keep_alive true
    working_dir etc/"openvpn"
  end

  test do
    system sbin/"openvpn", "--show-ciphers"
  end
end
