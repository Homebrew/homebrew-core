class Openvpn < Formula
  desc "SSL/TLS VPN implementing OSI layer 2 or 3 secure network extension"
  homepage "https://openvpn.net/community/"
  url "https://swupdate.openvpn.org/community/releases/openvpn-2.5.3.tar.xz"
  mirror "https://build.openvpn.net/downloads/releases/openvpn-2.5.3.tar.xz"
  sha256 "fb6a9943c603a1951ca13e9267653f8dd650c02f84bccd2b9d20f06a4c9c9a7e"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://openvpn.net/community-downloads/"
    regex(/href=.*?openvpn[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_big_sur: "fbcc7de1a4b69e3f347a572cae9936011af0dfb4f678aa6322a289ae838959cc"
    sha256 big_sur:       "ebcc6f226ebebc4be9a3ed47e59662731ae7b547dc452c7f5ba37c9775b98f0b"
    sha256 catalina:      "700335319b2d9491a89f6a4f01fff49510cf02abaa8828735318fa4021e62902"
    sha256 mojave:        "e986c3cf6d24e6bcb267b847b7167b2ce321798eee90a68194d7b0a3a477b15a"
    sha256 x86_64_linux:  "26f9cc78641866914d4318a0545e5555b4a5a87513ed6cbead9df091da161caf"
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
