class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  url "http://homebank.free.fr/public/homebank-5.5.3.tar.gz"
  sha256 "073607918a9610087791f36f59e70d1261fee8e4e1146a5cfd5871a1d2d91093"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://homebank.free.fr/public/"
    regex(/href=.*?homebank[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "a1aaa55de58c02e3d231bf3405d9d08e3ad95f11805627d668563e10b8bbaedb"
    sha256 big_sur:       "e5b90fc6091d2fdb03ce91eddf19a7dbbc9858414d582872ad285d3cec89e7cd"
    sha256 catalina:      "7dae6924cc50f1f445550ffb09a45518821936e5f6320661700e3b001c645f3e"
    sha256 mojave:        "9effe333c729e3b2c3622d1595f27ef6e187d20a7917adad53cfb922d83f9b91"
    sha256 x86_64_linux:  "d19777f6595d8b37ec6242b66f75c9297bbceea976eddd3fc4bf1d127c351d60"
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
  depends_on "libsoup"

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
