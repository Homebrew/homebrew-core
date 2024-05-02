class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  # A mirror is used as primary URL because the official one is unstable.
  url "https://deb.debian.org/debian/pool/main/h/homebank/homebank_5.7.4.orig.tar.gz"
  mirror "http://homebank.free.fr/public/sources/homebank-5.7.4.tar.gz"
  sha256 "42ce7146c875ea0ca3c93391b6a9bf4714db4621c63f4a094dcc6f8985bb54e4"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/h/homebank/"
    regex(/href=.*?homebank[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "a455ffc6c89184905ef95e86ad64f47c116d180c84403a76f3d3500c718e471e"
    sha256 arm64_ventura:  "a87b644ca8699ef4066056c4dd69249fd683b5640d8a5ba9845a520634fcd8e8"
    sha256 arm64_monterey: "bf68a6601ec1121d9819b36287ce21a14d60a4707989a1d57b9f85c6bde2c4ce"
    sha256 sonoma:         "86d67b8c23582998b26e6e2650e8f5ef126411786eb7166d784d94569702c8b3"
    sha256 ventura:        "c8ddf2d9b781aa06334e444a694f4b497cd12ebdc8a85b5e75c1b6c998c66939"
    sha256 monterey:       "43ecddb5048909cf26d9c51b8b1383d54bede58fbe582ef5ae0c548c1e1505dd"
    sha256 x86_64_linux:   "00ea39896f9ff78d82d92f7019aea04faa8a2d0575e66e76f711fd95831da772"
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

  uses_from_macos "perl"

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

  def install
    if OS.linux?
      ENV.prepend_path "PERL5LIB", Formula["perl-xml-parser"].libexec/"lib/perl5"
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
