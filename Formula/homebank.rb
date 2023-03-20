class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  # A mirror is used as primary URL because the official one is unstable.
  url "https://ftp.openbsd.org/pub/OpenBSD/distfiles/homebank-5.6.2.tar.gz"
  mirror "http://homebank.free.fr/public/sources/homebank-5.6.2.tar.gz"
  sha256 "12ebde58e04d3c18496f95496067c4e8841b0d111668d1f47c239292b15316f1"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://homebank.free.fr/public/sources/"
    regex(/href=.*?homebank[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "9a0f7a9a1b22bc24230b9d13b21d724fdd78f65bfe0d43a84c86089a262e2344"
    sha256 arm64_monterey: "846dc3e50b9f85dd1f525a488cf9ad4d58922e0c1bb376a7ca509e2ac01f03dc"
    sha256 arm64_big_sur:  "6c07c9571cefcf76e40bfe32ea8df396d3feb25c86b5e665d6d44b9a71f6022b"
    sha256 ventura:        "170ee9eba82ce1fbd4b5287b2b60126463a605697f4b06e22349067a89dc9f26"
    sha256 monterey:       "80d205842c5137922d0616f98347373127e36fef67b66d14466f5ff4779f5a59"
    sha256 big_sur:        "fd2d6680b33b81b81342ca779c356dcb6a784fe4006ac4bb8e5f243dcbd3c12b"
    sha256 x86_64_linux:   "babd749b1e63009cfd724165ebb465fb2507d8c1e8895f8eccc77a4894c319a4"
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
