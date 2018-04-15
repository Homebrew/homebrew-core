class PamYubico < Formula
  desc "Yubico pluggable authentication module"
  homepage "https://developers.yubico.com/yubico-pam/"
  url "https://developers.yubico.com/yubico-pam/Releases/pam_yubico-2.25.tar.gz"
  sha256 "624a5754d82665f6ba5f2e012f57cb41ea9bf61781ed2272dba49dffb4704e36"

  bottle do
    cellar :any
    sha256 "d70b4fd04ca757e1833c3f5e189e5a23ef4f55824ed42795d9e0dcc5e1181fe2" => :high_sierra
    sha256 "38457d50eca65fb936baa00d0164f71bd0d118ca0680e92d7d3a3e1b0979c487" => :sierra
    sha256 "33a3989b18a29eca9882aed319a0d38f94308e3b1e167a20905efabbde7c3466" => :el_capitan
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
