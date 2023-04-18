class GnomeLatex < Formula
  desc "LaTeX editor for the GNOME desktop"
  homepage "https://gitlab.gnome.org/swilmet/gnome-latex"
  url "https://download.gnome.org/sources/gnome-latex/3.44/gnome-latex-3.44.0.tar.xz"
  sha256 "88bd5340bd28c7ed01c7966a3a00732bbd902773df5ac659be6ad11806a9e744"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_ventura:  "f06efbf2dbba8b342210c88d0343a9ea7dcc0ea2635be6547e74d2caeb9cfa70"
    sha256 arm64_monterey: "51de73af3ae1d9c55c091d36268e1874d4edc12d73f8bbcf21925fd57c4b7b5a"
    sha256 arm64_big_sur:  "b067b352478df9a74e3650d1397485db30d255e1360c9265381bba9845ba8d5d"
    sha256 ventura:        "19a2472d46a29cc3fd5cd48883cf5ebbf7c8dbfe08c20208bb77564511962c40"
    sha256 monterey:       "3c4c5d295ffee44a5c7acbff6ff0b9e5bc9eef749584861b35d46397d03446a9"
    sha256 big_sur:        "04f05bd4f4c55742f72673520076ce9899df5934f9421deff5344d8177298637"
    sha256 x86_64_linux:   "7e243ca213ca46495cc3798a5b6a5d7fae042da5a25537608c67d1a6ea704704"
  end

  head do
    url "https://gitlab.gnome.org/swilmet/gnome-latex.git", branch: "main"

    depends_on "appstream-glib" => :build
    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build
    depends_on "automake" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build
    depends_on "vala" => :build
    depends_on "yelp-tools" => :build
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "itstool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "amtk"
  depends_on "glib"
  depends_on "gspell"
  depends_on "gtk+3"
  depends_on "gtksourceview4"
  depends_on "libgee"
  depends_on "tepl"

  def install
    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, *std_configure_args,
                      "--disable-schemas-compile",
                      "--disable-silent-rules",
                      "--disable-code-coverage",
                      "--disable-dconf-migration"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas",
           "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t",
           "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    system "#{bin}/gnome-latex", "--version"
  end
end
