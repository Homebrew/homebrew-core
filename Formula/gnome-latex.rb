class GnomeLatex < Formula
  desc "LaTeX editor for the GNOME desktop"
  homepage "https://gitlab.gnome.org/swilmet/gnome-latex"
  url "https://gitlab.gnome.org/swilmet/gnome-latex.git",
      tag:      "3.41.2",
      revision: "1919ae4326505eb8834db3312e06fdab8caf6a09"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_monterey: "45cb26496d4884a7ba463cd5ce28977e0f72116e7b40dcda9545bbcb44bcf11a"
    sha256 arm64_big_sur:  "f452e0f94f155fffb2390ffd38d1f28b2c6c61163081d8ae8e86b57f07d6dcb6"
    sha256 monterey:       "2979c8035dd7809e97bcc520f098e0b2af6081062f9505420f91fa48d08871f6"
    sha256 big_sur:        "1e55c7ece5420a38bbe098e9cd708579deb2322a3a33722cbf63005d788894a5"
    sha256 catalina:       "604adc337f113bb09396d0f6173608e2fc45d6573813c286bbd096ebcdfffbe8"
    sha256 x86_64_linux:   "82ec9fe1be1351534758903717eaff522ddec1c672278f9b8b4d91d2940da12d"
  end

  depends_on "appstream-glib" => :build
  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "gobject-introspection" => :build
  depends_on "gtk-doc" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "yelp-tools" => :build
  depends_on "adwaita-icon-theme"
  depends_on "gnome-themes-standard"
  depends_on "gspell"
  depends_on "libgee"
  depends_on "tepl"

  uses_from_macos "perl" => :build

  def install
    # Needed by intltool (xml::parser)
    ENV.prepend_path "PERL5LIB", "#{Formula["intltool"].libexec}/lib/perl5" unless OS.mac?

    system "./autogen.sh", "--disable-schemas-compile",
                           "--disable-dependency-tracking",
                           "--disable-silent-rules",
                           "--disable-code-coverage",
                           "--disable-dconf-migration",
                           "--prefix=#{prefix}"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas",
           "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t",
           "#{HOMEBREW_PREFIX}/share/icons/hicolor"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t",
           "#{HOMEBREW_PREFIX}/share/icons/HighContrast"
  end

  test do
    system "#{bin}/gnome-latex", "--version"
  end
end
