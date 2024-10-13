class Openvpn < Formula
  desc "SSL/TLS VPN implementing OSI layer 2 or 3 secure network extension"
  homepage "https://openvpn.net/community/"
  url "https://swupdate.openvpn.org/community/releases/openvpn-2.6.12.tar.gz"
  mirror "https://build.openvpn.net/downloads/releases/openvpn-2.6.12.tar.gz"
  sha256 "1c610fddeb686e34f1367c347e027e418e07523a10f4d8ce4a2c2af2f61a1929"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://openvpn.net/community-downloads/"
    regex(/href=.*?openvpn[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "8282b3a36803bef68a01a98cfa1c9f7b823ffe34ee3b95d6e34b0e029a6005ed"
    sha256 arm64_sonoma:   "ec2cc2ff01475426a9d140a04f480750dea45ddb77ff60803c027cc69d356109"
    sha256 arm64_ventura:  "a9972bf495e2ab0540046e2d08cd38d03c0f05dd56cc6506aabccbe8d0ed696e"
    sha256 arm64_monterey: "804b5bea4a96975bbe81828bb95a4163d848549360a795d12360784b2a745ca2"
    sha256 sonoma:         "dd0244cc7150e8c75ce1077fa8c02abee0aac9cf6f6da4007971dffa189470a7"
    sha256 ventura:        "a76b76a20e5fd17a75b65610643158287b2c663df626878cb305c7881713a865"
    sha256 monterey:       "3eeb589dcfdc1d9d14b9b6f2ad1a49285a66454f7b87f376b283e4f950254e4c"
    sha256 x86_64_linux:   "eb42fbd2153609daa6953f0772fef04980198877eb4af8699ca7381a3f8e2bd0"
  end

  depends_on "pkg-config" => :build
  depends_on "lz4"
  depends_on "lzo"
  depends_on "openssl@3"
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
