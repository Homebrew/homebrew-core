class PamYubico < Formula
  desc "Yubico pluggable authentication module"
  homepage "https://developers.yubico.com/yubico-pam/"
  url "https://developers.yubico.com/yubico-pam/Releases/pam_yubico-2.23.tar.gz"
  sha256 "bc7193ed10c8fb7a2878088af859a24a7e6a456e1728a914eb5ed47cdff0ecb8"

  bottle do
    cellar :any
    sha256 "47c9f7f34c354739bc233c3e90d12d5cb11629908873e944681900360e0ba1f9" => :el_capitan
    sha256 "d8914ea3e39c4073ee04abbf76cbf193517904965b088a0eee4093f2bff6c823" => :yosemite
    sha256 "201530802d1f18865175e242e9595550318e4579d41e1f9619cadb4de8e9be5d" => :mavericks
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "libyubikey"
  depends_on "ykclient"
  depends_on "ykpers"

  def install
    ENV.universal_binary if build.universal?
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
