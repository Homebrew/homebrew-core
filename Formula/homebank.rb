class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  url "http://homebank.free.fr/public/homebank-5.5.2.tar.gz"
  sha256 "989ef378e4c9f8234b62bb93d6a4b14bd4c98dc889519838dba1f44f12c51ed2"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://homebank.free.fr/public/"
    regex(/href=.*?homebank[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "4dcbdaefbbc1ca950c46251ac6f4256aa0a2b2192b65f87c6126b6238662eca1"
    sha256 big_sur:       "1955afa29d38dd9b3e6c163c76aa37956991ccc31a3a045419fa38cbf0ae9a7f"
    sha256 catalina:      "cacd1016658a98006e90ee2c846be0b8737396345083c0016b3dd4aa79a6d04e"
    sha256 mojave:        "2fbcca1d33171012b17c4d5e103ae68223ac513cc1c1866a21886eafb892c758"
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
    on_linux do
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
