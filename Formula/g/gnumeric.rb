class Gnumeric < Formula
  desc "GNOME Spreadsheet Application"
  homepage "https://projects.gnome.org/gnumeric/"
  url "https://download.gnome.org/sources/gnumeric/1.12/gnumeric-1.12.60.tar.xz"
  sha256 "bb02feb286062805564438534e1fea459f97cebac8a090b1a7e47ca251e07467"
  license any_of: ["GPL-3.0-only", "GPL-2.0-only"]

  bottle do
    sha256                               arm64_tahoe:   "02e980a333f1147f76517adf6aef59f34d85d8e0ad5139e4d00bc726cc7bc27f"
    sha256                               arm64_sequoia: "f56d25431c4d976c9aabb4e630a6a4f5cd3e2bce3c91a17595ca6d96b65c2a21"
    sha256                               arm64_sonoma:  "546789bb7b3a30a6a791060bbd852eabcdc12b5a5c0dd1b6380feb6ddf251b94"
    sha256                               sonoma:        "fbe5478953b752c3777bb6f782f69fe0d7905b7eae318aa6c97ec156ed3033b5"
    sha256                               arm64_linux:   "8bbb3ef361de7939d9e205eee5d13e361e529ee88cf0b1ce36eaa472fa420b6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "758c3360118c9db83b015d1ff4713664ba68c50b48abcb122c906f5c80ad5fc5"
  end

  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "pkgconf" => :build

  depends_on "adwaita-icon-theme"
  depends_on "at-spi2-core"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "goffice"
  depends_on "gtk+3"
  depends_on "libgsf"
  depends_on "libxml2"
  depends_on "pango"

  uses_from_macos "bison" => :build
  uses_from_macos "python" => :build
  uses_from_macos "perl"

  on_macos do
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "perl-xml-parser" => :build
    depends_on "zlib-ng-compat"
  end

  # Replace `bool` type (which requires stdbool.h) with `gboolean`
  # https://gitlab.gnome.org/GNOME/gnumeric/-/merge_requests/39/commits
  patch do
    url "https://gitlab.gnome.org/GNOME/gnumeric/-/commit/0de4c0a45f078ec211fd372da4103b09cb718b1b.diff"
    sha256 "ac4f245417fcf2d627503ec86aa78fc73becca43c39c7c6ab7c137db55ff48b1"
  end

  def install
    # ensures that the files remain within the keg
    inreplace "component/Makefile.in",
              "GOFFICE_PLUGINS_DIR = @GOFFICE_PLUGINS_DIR@",
              "GOFFICE_PLUGINS_DIR = @libdir@/goffice/@GOFFICE_API_VER@/plugins/gnumeric"

    system "./configure", "--disable-schemas-compile",
                          "--disable-silent-rules",
                          *std_configure_args
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    system bin/"gnumeric", "--version"
  end
end
