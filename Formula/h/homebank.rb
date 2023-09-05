class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  # A mirror is used as primary URL because the official one is unstable.
  url "https://deb.debian.org/debian/pool/main/h/homebank/homebank_5.6.5.orig.tar.gz"
  mirror "http://homebank.free.fr/public/sources/homebank-5.6.5.tar.gz"
  sha256 "b5494dfcf87d7a8572696a2afa2a04496ba79e3857cd3e3b18ac03bd1b6d2ca8"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://homebank.free.fr/public/sources/"
    regex(/href=.*?homebank[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "823c59b268c4ecfbc0ce6f41a6d4e163f220328a9372c55f74600df49091bd75"
    sha256 arm64_monterey: "863be05486d2cec3a2c26047fecd5a2e18589b8070af8cf10d98273b5f9a4579"
    sha256 arm64_big_sur:  "2ac06c19e7389bf818594fbfaeb195abbab67532e4f8f15bcf2062ad7e442019"
    sha256 ventura:        "87a1cad60518869e3ddc82c0a02b32783b8661a04cbf65d65ee4963301ff2316"
    sha256 monterey:       "b478bd78a5dff976268d7e5fea71a4cc154f9bb128217690bb25f74bc1e0cea8"
    sha256 big_sur:        "113bd9f7f2061e6f8fd64052187049085115c8bcc9c139d975b4d173a25f6063"
    sha256 x86_64_linux:   "dffd3f69785c13d21f412db1fa4cec636fe887b0922c080ba2da59176369a589"
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gettext"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "libofx"
  depends_on "libsoup@2"

  def install
    if OS.linux?
      # Needed to find intltool (xml::parser)
      ENV.prepend_path "PERL5LIB", Formula["intltool"].libexec/"lib/perl5"
      ENV["INTLTOOL_PERL"] = Formula["perl"].bin/"perl"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--with-ofx"
    chmod 0755, "./install-sh"
    system "make", "install"
  end

  test do
    system "#{bin}/homebank", "--version"
  end
end
