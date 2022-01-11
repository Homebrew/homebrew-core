class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  url "http://homebank.free.fr/public/homebank-5.5.4.tar.gz"
  sha256 "0d0669bca099340ae5c213ea13cb2b93283bfc8a0e4cf7a5902c1829366e5765"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://homebank.free.fr/public/"
    regex(/href=.*?homebank[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_big_sur: "9886da1f9d7dfb98b13ac1808b4318864282a055269b25da19e5f1453cc1a588"
    sha256 monterey:      "f2899fa483e5da1fa95a8e97946a9c555c94b6be3fe6455151fa92e741c40441"
    sha256 big_sur:       "5936596838042fc63daec2e53293f5b3bae29fe78f196ebd3ecca9101f1dacb8"
    sha256 catalina:      "d9c3421acd5e7aa1e3bce9ef2ac4009a7fa3d93941b5ae11fd60e48e9dd8dfe0"
    sha256 x86_64_linux:  "d61e170159b6d68f64712b5fae3cc50d881c670f444df0fbf1133d845129a957"
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
