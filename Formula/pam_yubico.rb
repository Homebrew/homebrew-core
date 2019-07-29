class PamYubico < Formula
  desc "Yubico pluggable authentication module"
  homepage "https://developers.yubico.com/yubico-pam/"
  url "https://developers.yubico.com/yubico-pam/Releases/pam_yubico-2.26.tar.gz"
  sha256 "2de96495963fefd72b98243952ca5d5ec513e702c596e54bc667ef6b5e252966"

  bottle do
    cellar :any
    sha256 "bb57ab33d7b79a6461648cd510d5524ea636db738c46bba5aa8f1fe8451c4e49" => :mojave
    sha256 "a9a21d8b84d95c76d13118d1c525b93f9bbdf5c49b8aae5304df966d1a1ea669" => :high_sierra
    sha256 "7b0027b330f0f2bb6da798a7b405d80e09db71892c403206ba6c31bed5a3c804" => :sierra
    sha256 "102680d53f9ef736089e1e4a4eeaab60962fbbf4156c1fb3e77d82f425b0eed7" => :el_capitan
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
