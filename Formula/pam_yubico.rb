class PamYubico < Formula
  desc "Yubico pluggable authentication module"
  homepage "https://developers.yubico.com/yubico-pam/"
  url "https://developers.yubico.com/yubico-pam/Releases/pam_yubico-2.24.tar.gz"
  sha256 "0326ff676e2b32ed1dda7fb5f1358a22d629d71caad8f8db52138bbf3e95e82d"

  bottle do
    cellar :any
    sha256 "68098087eb87639f10607c030e58b7cf7ae86a8a95ff863a17ca1e7cfa2ca5b0" => :sierra
    sha256 "ce01a964d539a569478c9dd882a9652354d9d7ab35d935df9aa543eb31716b58" => :el_capitan
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
