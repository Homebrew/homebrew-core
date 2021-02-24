class PamYubico < Formula
  desc "Yubico pluggable authentication module"
  homepage "https://developers.yubico.com/yubico-pam/"
  url "https://developers.yubico.com/yubico-pam/Releases/pam_yubico-2.26.tar.gz"
  sha256 "2de96495963fefd72b98243952ca5d5ec513e702c596e54bc667ef6b5e252966"
  license "BSD-2-Clause"
  revision 1

  livecheck do
    url "https://developers.yubico.com/yubico-pam/Releases/"
    regex(/href=.*?pam_yubico[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "e4d52181c23e4dbb74d4a6a37c63bbaf13103bedc4e2b069951d70eaca3059e7"
    sha256 cellar: :any, big_sur:       "2b18722e8124e7925ebaa30f675b6053cf62cc40b297be22b5a3cfbddc208e46"
    sha256 cellar: :any, catalina:      "6e4eb4afca28e15098998d561b21ab65930ab57898fcf26ed0ba657263d2f130"
    sha256 cellar: :any, mojave:        "3679137d1149195219a4cc36154356f8d749b757d47ec7ab75850ae9eace84e8"
    sha256 cellar: :any, high_sierra:   "a321eb909c66465f67e0a25e9e38df33cc2d76c6e9ac9c834cb7ba17b247597f"
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
