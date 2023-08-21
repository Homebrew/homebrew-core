class Openvpn < Formula
  desc "SSL/TLS VPN implementing OSI layer 2 or 3 secure network extension"
  homepage "https://openvpn.net/community/"
  url "https://swupdate.openvpn.org/community/releases/openvpn-2.6.6.tar.gz"
  mirror "https://build.openvpn.net/downloads/releases/openvpn-2.6.6.tar.gz"
  sha256 "3b074f392818b31aa529b84f76e8b5e4ad03fca764924f46d906bceaaf421034"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://openvpn.net/community-downloads/"
    regex(/href=.*?openvpn[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "90fa0bc4446ec74b6960e31da35cfd68cb6f5274e89cf9ac5a597b4e4637d201"
    sha256 arm64_monterey: "3599d01966e84ea970cd3ef647ebb5066fcbcc633eaf73d2060c7db0feadd606"
    sha256 arm64_big_sur:  "7a23d546b99abb821b383683600d12f93f3de0f7c8927d145f608d93bd0ca57c"
    sha256 ventura:        "d0201b56e1789ef40d1c4c977101e6c7554fe0e39e5792c6d62397c6bdba4eff"
    sha256 monterey:       "fada3e8687febce89f1dde74d84e9963655317f4258e4676be3214c60a2be4cd"
    sha256 big_sur:        "166075b0deb1433fcfbed19bd865751f6e5fef7a81dc5ae5c0fdd6e92b00dc09"
    sha256 x86_64_linux:   "629aabf94720653698e10595852cfe2df3f5b5b0eaffb72afd6479577650e6fb"
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
