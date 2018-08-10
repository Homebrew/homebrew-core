class Gnumeric < Formula
  desc "GNOME Spreadsheet Application"
  homepage "https://projects.gnome.org/gnumeric/"
  url "https://download.gnome.org/sources/gnumeric/1.12/gnumeric-1.12.42.tar.xz"
  sha256 "54def8f93ab4858e2ed6499e2731c4393c1e94993696c944bd755a7a0879146d"

  bottle do
    sha256 "e94cfece4b3b16f26b835b849ef9d7eaea0633a21b6b0adc68b465c30a874ddc" => :high_sierra
    sha256 "979a65648dadf239f03fa8a9d702dae18288f20c3f1355de8bd44394aa2dff2e" => :sierra
    sha256 "c8cd4b78af3e7d88850a0adbe3f29bc2a1ba3c09ddc53cfd16469c5d9a6ad531" => :el_capitan
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
