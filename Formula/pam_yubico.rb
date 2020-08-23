class PamYubico < Formula
  desc "Yubico pluggable authentication module"
  homepage "https://developers.yubico.com/yubico-pam/"
  url "https://developers.yubico.com/yubico-pam/Releases/pam_yubico-2.26.tar.gz"
  sha256 "2de96495963fefd72b98243952ca5d5ec513e702c596e54bc667ef6b5e252966"
  license "BSD-2-Clause"
  revision 1

  bottle do
    cellar :any
    sha256 "6e4eb4afca28e15098998d561b21ab65930ab57898fcf26ed0ba657263d2f130" => :catalina
    sha256 "3679137d1149195219a4cc36154356f8d749b757d47ec7ab75850ae9eace84e8" => :mojave
    sha256 "a321eb909c66465f67e0a25e9e38df33cc2d76c6e9ac9c834cb7ba17b247597f" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libyubikey"
  depends_on "ykclient"
  depends_on "ykpers"

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    system "./configure", "--prefix=#{prefix}",
                          "--with-libyubikey-prefix=#{Formula["libyubikey"].opt_prefix}",
                          "--with-libykclient-prefix=#{Formula["ykclient"].opt_prefix}"
    system "make", "install"
  end

  test do
    # Not much more to test without an actual yubikey device.
    system "#{bin}/ykpamcfg", "-V"
  end
end
