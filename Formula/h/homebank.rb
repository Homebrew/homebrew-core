class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  # A mirror is used as primary URL because the official one is unstable.
  url "https://deb.debian.org/debian/pool/main/h/homebank/homebank_5.7.3.orig.tar.gz"
  mirror "http://homebank.free.fr/public/sources/homebank-5.7.3.tar.gz"
  sha256 "69df172a599acd66629bf98b3669ec152cb93a78bbcafdc7431617dd25f35dc5"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/h/homebank/"
    regex(/href=.*?homebank[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "f634ca1029e4b3d14c3779a1a2ad25fc0cee33a78e500a7f182896fd9c6c08e2"
    sha256 arm64_ventura:  "4c8300f5040a5acc4556998ade2c9e09f9a3970848f35c396ec26f46dc936291"
    sha256 arm64_monterey: "2ac04762029b864795d5349c2c9ffab0615d40305c5a392f02d803581f2e0d61"
    sha256 sonoma:         "fc9a2ca2cb488e030ee6b1095b7d2fc2cc154185d07a62caf4a89ff956832af6"
    sha256 ventura:        "bed7b2714349a43e8ef4634014e5f4525426a1c98474522356c917e75672a6fe"
    sha256 monterey:       "f733589af17dbe776707e2a3b57faad3b184c0da457e9f7d7422fbb716233a82"
    sha256 x86_64_linux:   "0189596f1f99cf0c5e3e95c6f2488e8308e34b0308f04809cdab9fc168d63c5c"
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
