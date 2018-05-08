class Gnumeric < Formula
  desc "GNOME Spreadsheet Application"
  homepage "https://projects.gnome.org/gnumeric/"
  url "https://download.gnome.org/sources/gnumeric/1.12/gnumeric-1.12.41.tar.xz"
  sha256 "66f6e665b7b6d708537295d8cbd00c5cb4efe31f605d5e646f38a7beab565969"

  bottle do
    sha256 "7f8ba4094f7933d9e319bc15de6c369031a20dd9e39504525de8f07c74bb57cc" => :high_sierra
    sha256 "11472a3806d6c6617e67f0030888a885aea8d0cfd00126507e04a1b17865dd7d" => :sierra
    sha256 "2c2ea4a108322e3b2128ea0f52ebcc753c884df600ce957ff61cfac3de8a4385" => :el_capitan
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
