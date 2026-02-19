class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://pygobject.gnome.org"
  url "https://download.gnome.org/sources/pygobject/3.54/pygobject-3.54.5.tar.gz"
  sha256 "b6656f6348f5245606cf15ea48c384c7f05156c75ead206c1b246c80a22fb585"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7cc2327a27298ec1c57d4d751b7fca8f22f23ddd7940bc9bfde112f461433621"
    sha256 cellar: :any, arm64_sequoia: "b67057e4a6d222d2d7de913305a620d4f35f3e3dfc6249a794b918d80b778af1"
    sha256 cellar: :any, arm64_sonoma:  "a0834eec43887a3b8c7924215b909ff2f4ed5495a5049123cb96a3f876d12095"
    sha256 cellar: :any, sonoma:        "30ebc00d2c80ba7fa169019c363f2cb16fccdb26709faab469f5dcbb7ba7a6ae"
    sha256               arm64_linux:   "81b896d550dc7e52d18678558152cbd20ff692f27eebd480dca8293325287623"
    sha256               x86_64_linux:  "915f6aafd4d607348675e47d00c8eab241232d184e28998073dd69661c17cbeb"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => [:build, :test]
  depends_on "python@3.14" => [:build, :test]

  depends_on "cairo"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "py3cairo"

  uses_from_macos "libffi"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python|
      xy = Language::Python.major_minor_version(python)
      builddir = "buildpy#{xy}".delete(".")
      site_packages = prefix/Language::Python.site_packages(python)

      system "meson", "setup", builddir, "-Dpycairo=enabled",
                                         "-Dpython=#{python}",
                                         "-Dpython.platlibdir=#{site_packages}",
                                         "-Dpython.purelibdir=#{site_packages}",
                                         "-Dtests=false",
                                         *std_meson_args
      system "meson", "compile", "-C", builddir, "--verbose"
      system "meson", "install", "-C", builddir
    end
  end

  test do
    Pathname("test.py").write <<~PYTHON
      import gi
      gi.require_version("GLib", "2.0")
      assert("__init__" in gi.__file__)
      from gi.repository import GLib
      assert(31 == GLib.Date.get_days_in_month(GLib.DateMonth.JANUARY, 2000))
    PYTHON

    pythons.each do |python|
      system python, "test.py"
    end
  end
end
