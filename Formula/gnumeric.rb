class Gnumeric < Formula
  desc "GNOME Spreadsheet Application"
  homepage "https://projects.gnome.org/gnumeric/"
  url "https://download.gnome.org/sources/gnumeric/1.12/gnumeric-1.12.37.tar.xz"
  sha256 "40371b9587857deefb0d1df950c3e02228d3f9b56def2e3aa86736ee24292468"

  bottle do
    sha256 "c07f651bced40f89a8140c27ab517b543fe8f5211c60c951c4ec5ed397a73413" => :high_sierra
    sha256 "1bbe44ea1336f8ba6dd78b006b848da046976a696298c62f4839d0b018e1125c" => :sierra
    sha256 "e5240123da0a76481a979688d94c5f9723d4e0541c41038a4fae2b50c26813fb" => :el_capitan
  end

  option "with-python-scripting", "Enable Python scripting."

  deprecated_option "python-scripting" => "with-python-scripting"

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "goffice"
  depends_on "rarian"
  depends_on "adwaita-icon-theme"
  depends_on "pygobject" if build.with? "python-scripting"

  # Issue from 26 Nov 2017 "itstool-2.0.4: problem with gnumeric-1.12.35"
  # See https://github.com/itstool/itstool/issues/22
  resource "itstool" do
    url "http://files.itstool.org/itstool/itstool-2.0.2.tar.bz2"
    sha256 "bf909fb59b11a646681a8534d5700fec99be83bb2c57badf8c1844512227033a"
  end

  # For itstool
  resource "py_libxml2" do
    url "http://xmlsoft.org/sources/libxml2-2.9.7.tar.gz"
    sha256 "f63c5e7d30362ed28b38bfa1ac6313f9a80230720b7fb6c80575eeab3ff5900c"
  end

  # Fix "no member named 'libintl_textdomain' in 'struct _GnmFunc'"
  # Equivalent to the following two upstream commits from 25 Dec 2017:
  # https://github.com/GNOME/gnumeric/commit/7017a7ee2
  # https://github.com/GNOME/gnumeric/commit/64f1410b7
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/ee23995/gnumeric/textdomain.patch"
    sha256 "68c4a71a25551bdbbdf4af83fd707fe581f55356f89c9ef21553775bebe3de43"
  end

  def install
    resource("py_libxml2").stage do
      cd "python" do
        system "python", "setup.py", "install", "--prefix=#{buildpath}/vendor"
      end
    end

    resource("itstool").stage do
      ENV.append_path "PYTHONPATH", "#{buildpath}/vendor/lib/python2.7/site-packages"
      system "./configure", "--prefix=#{buildpath}/vendor"
      system "make", "install"
    end

    ENV.prepend_path "PATH", buildpath/"vendor/bin"

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
