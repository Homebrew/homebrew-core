class Openvpn < Formula
  desc "SSL/TLS VPN implementing OSI layer 2 or 3 secure network extension"
  homepage "https://openvpn.net/community/"
  url "https://swupdate.openvpn.org/community/releases/openvpn-2.6.14.tar.gz"
  mirror "https://build.openvpn.net/downloads/releases/openvpn-2.6.14.tar.gz"
  sha256 "9eb6a6618352f9e7b771a9d38ae1631b5edfeed6d40233e243e602ddf2195e7a"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://openvpn.net/community-downloads/"
    regex(/href=.*?openvpn[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "d304c987b52e8ceab1217df11dc29d146cb7365691c204a198083b6ddac212a6"
    sha256 arm64_sonoma:  "02b8aa3654cc4b7a849edf562c2d38f5d99117351eff12cd3bb3aed0518d394c"
    sha256 arm64_ventura: "b842dee9d24123a0926ea9ea4a050b85b5e440597dfbf07e2e1b078f468ecf50"
    sha256 sonoma:        "c87079ceb7eff3e98c9918243698dd4d3f1f499a52a9250fc235b5f7615d666e"
    sha256 ventura:       "61e23b893b99b322dcbe38e006a6d2016c654099970add6357c99dac6be5e692"
    sha256 arm64_linux:   "0c18f74edca2b997ef8b663487f796f715a7bce351a08c2c97992614c3f05102"
    sha256 x86_64_linux:  "27fde18eb1f1bc5105c2a94812af5e270ef7eead8acec56446a620718613a00e"
  end

  depends_on "pkgconf" => :build
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
    system "./configure", "--disable-silent-rules",
                          "--with-crypto-library=openssl",
                          "--enable-pkcs11",
                          *std_configure_args
    inreplace "sample/sample-plugins/Makefile" do |s|
      if OS.mac?
        s.gsub! Superenv.shims_path/"pkg-config", Formula["pkgconf"].opt_bin/"pkg-config"
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
