class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  url "http://homebank.free.fr/public/homebank-5.5.5.tar.gz"
  sha256 "bece05ecb52392147424aa1e5a179389777b82bf468abebd73eb70b2af9c9e67"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://homebank.free.fr/public/"
    regex(/href=.*?homebank[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "97df3402f51f1c1edc03d6d086aae9d9f1dad08be0cdf8705db52382458b3889"
    sha256 arm64_big_sur:  "c8cf6d6a3ee32b8207793f2dd76f0c00f5c09f8a693bb2f5983460532f35c9a7"
    sha256 monterey:       "34554948850e7c882dafe8d0ac8f3c48a7e9b61ba940eeca3a2a6d02714a071e"
    sha256 big_sur:        "36fc5288291f211475e8662b7fa95f9863176f8e728bbac4fcdc4ad670ccc3a4"
    sha256 catalina:       "04a41b0a632e90416fc6746998e5787d55d22414f77c5caf142759d70bb49e7e"
    sha256 x86_64_linux:   "4188b2b9f658735982c223e1893b254a090da26eefbd06e43b1df5f05cb57036"
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
