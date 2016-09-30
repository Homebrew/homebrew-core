class PamYubico < Formula
  desc "Yubico pluggable authentication module"
  homepage "https://developers.yubico.com/yubico-pam/"
  url "https://developers.yubico.com/yubico-pam/Releases/pam_yubico-2.23.tar.gz"
  sha256 "bc7193ed10c8fb7a2878088af859a24a7e6a456e1728a914eb5ed47cdff0ecb8"

  bottle do
    cellar :any
    sha256 "96f7147fccca005c066d53b1e6ba2bee6013c847b6bc0ec188d8af22e337870a" => :sierra
    sha256 "5d9cb094345cede6f701f686f6660ae59c47b03192e85fa8701e6730ce859027" => :el_capitan
    sha256 "93769c01776befd585bfcbd1f07992c695e5e3d65f33b8b656a04a4d1ddfb7c9" => :yosemite
    sha256 "8b68985a95c26661f9cad4467449a60e826cbbf95e67c20a2edbbcf474cf13f6" => :mavericks
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
