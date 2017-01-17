class Gnumeric < Formula
  desc "GNOME Spreadsheet Application"
  homepage "https://projects.gnome.org/gnumeric/"
  url "https://download.gnome.org/sources/gnumeric/1.12/gnumeric-1.12.32.tar.xz"
  sha256 "a07bc83e2adaeb94bfa2c737c9a19d90381a19cb203dd7c4d5f7d6cfdbee6de8"

  bottle do
    sha256 "edc34ae12d2b0d9cc449127c7d21ca478786017752ec2285477489d75501a316" => :sierra
    sha256 "9ebd3e872916c958ecbbed29f56e13a1f91c86c3b0bcba7965af76b93f402f04" => :el_capitan
    sha256 "c97accc2410d6f685adcc6fbe631bba26d3a3bfae9241ba7a2c60443a5c04c1d" => :yosemite
  end

  option "with-python-scripting", "Enable Python scripting."

  deprecated_option "python-scripting" => "with-python-scripting"

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "goffice"
  depends_on "rarian"
  depends_on "gnome-icon-theme"
  depends_on "pygobject" if build.with? "python-scripting"

  def install
    # ensures that the files remain within the keg
    inreplace "component/Makefile.in",
              "GOFFICE_PLUGINS_DIR = @GOFFICE_PLUGINS_DIR@",
              "GOFFICE_PLUGINS_DIR = @libdir@/goffice/@GOFFICE_API_VER@/plugins/gnumeric"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-schemas-compile"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    system bin/"gnumeric", "--version"
  end
end
