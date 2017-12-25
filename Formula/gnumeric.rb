class Gnumeric < Formula
  desc "GNOME Spreadsheet Application"
  homepage "https://projects.gnome.org/gnumeric/"
  url "https://download.gnome.org/sources/gnumeric/1.12/gnumeric-1.12.37.tar.xz"
  sha256 "40371b9587857deefb0d1df950c3e02228d3f9b56def2e3aa86736ee24292468"

  bottle do
    rebuild 1
    sha256 "eee1f26786c0c4773616dc6e1a2bd1e60f1697321310e99f0e875e45300f59f8" => :high_sierra
    sha256 "606c2d0fc786ee45c0a7e3349def6e596ce666518d53dc2ef583a309da5a9b8e" => :sierra
    sha256 "1955c0ae14d94c849b399c19485bc16f7bb981ee84ecc926d8cefd1494a67b39" => :el_capitan
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
