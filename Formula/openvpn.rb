class Openvpn < Formula
  desc "SSL/TLS VPN implementing OSI layer 2 or 3 secure network extension"
  homepage "https://openvpn.net/community/"
  url "https://swupdate.openvpn.org/community/releases/openvpn-2.5.4.tar.xz"
  mirror "https://build.openvpn.net/downloads/releases/openvpn-2.5.4.tar.xz"
  sha256 "56c0dcd27ab938c4ad07469c86eb8b7408ef64c3e68f98497db8c03f11792436"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://openvpn.net/community-downloads/"
    regex(/href=.*?openvpn[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "02af3b44c4340fcbcfdcc2cbb8800f5ec0701fc1dc1cbf8a4ec1df8cf539933d"
    sha256 arm64_big_sur:  "6666fe4dc8bfa42db9bb92d52962606daacfa284be240e183de86f568ac2af43"
    sha256 monterey:       "632edbc545de24e3a4ae0b3bbf4872d38ff5c0e8cefce4c6db71c35ac6435e56"
    sha256 big_sur:        "682a9cd67a9ca4d1f3e98b2278bfb30cba39e30f532cdebbc25258fe7e4e69af"
    sha256 catalina:       "904507f9c962a7294f67a92e48d0c8cfc12a71bcf91c6d5d924e0f28a4836a3a"
    sha256 mojave:         "fec0ed2726d148cc96ac6a19a9dfa0e39703fba82c717020f5c6ccc1ee4deef9"
    sha256 x86_64_linux:   "a8d95b95acf6cdfed376475c0e5265bc97bac433dbb51c7279f0bb76a39db6a2"
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
