class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://pygobject.gnome.org"
  url "https://download.gnome.org/sources/pygobject/3.50/pygobject-3.50.0.tar.xz"
  sha256 "8d836e75b5a881d457ee1622cae4a32bcdba28a0ba562193adb3bbb472472212"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_sequoia: "2c86ffbaf32b22811f8fff5a6040677f4268af2578660fb007a5c5d4956c1133"
    sha256 cellar: :any, arm64_sonoma:  "e8d0149368484d81a54f759a584db813c3184e630504b61534b734949bc286fc"
    sha256 cellar: :any, arm64_ventura: "def28c144b1960f13894245dbb785fbef6862557e36b9b8ddc13953896807b9e"
    sha256 cellar: :any, sonoma:        "3fd16304b9bea30514a67e69e74d9aeb6fc84aec60bbbe21f25ae5a4790323b0"
    sha256 cellar: :any, ventura:       "fb878d036fe1ac67746de24cd89eadd9fb1921f005d34e283f9772426a923384"
    sha256               x86_64_linux:  "35b1199c46cd42b0e3adbe11e4587ab1fc6abd2715eb1e6a562fb22d032c3746"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.12" => [:build, :test]
  depends_on "python@3.13" => [:build, :test]

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
