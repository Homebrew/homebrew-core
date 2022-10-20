class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://wiki.gnome.org/Projects/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.42/pygobject-3.42.2.tar.xz"
  sha256 "ade8695e2a7073849dd0316d31d8728e15e1e0bc71d9ff6d1c09e86be52bc957"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_monterey: "b23d2ff0d41aa60565d2d39d686fdb303b460736fbb3d90a6a0216f69e3c8340"
    sha256 cellar: :any, arm64_big_sur:  "11066e4adfe52f9af0091504ad7207d6587503dbe96d07ef5ab880ec36e49442"
    sha256 cellar: :any, monterey:       "d57091970521b9d1aefc9a904aa2ddf7e3c80c40f28ccdbe48d2381dfc1bc2b6"
    sha256 cellar: :any, big_sur:        "a0f3a0816f12e72f11a09cfb480e93362051e07c952ec0a330526eb3984b64ff"
    sha256 cellar: :any, catalina:       "7b0142d6eeb8c1876284207430fd917db6a9bec691ab8629262b96ef1627073b"
    sha256               x86_64_linux:   "964ea643f29ae15c098846594fa43343a3525acbe489d756650f9efef629a473"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.9" => [:build, :test]
  depends_on "gobject-introspection"
  depends_on "py3cairo"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def site_packages(python)
    prefix/Language::Python.site_packages(python)
  end

  def install
    pythons.each do |python|
      xy = Language::Python.major_minor_version(python)
      builddir = "buildpy#{xy}".delete(".")

      system "meson", "setup", builddir, "-Dpycairo=enabled",
                                         "-Dpython=#{python}",
                                         "-Dpython.platlibdir=#{site_packages(python)}",
                                         "-Dpython.purelibdir=#{site_packages(python)}",
                                         *std_meson_args

      system "meson", "compile", "-C", builddir, "--verbose"
      system "meson", "install", "-C", builddir
    end
  end

  test do
    Pathname("test.py").write <<~EOS
      import gi
      gi.require_version("GLib", "2.0")
      assert("__init__" in gi.__file__)
      from gi.repository import GLib
      assert(31 == GLib.Date.get_days_in_month(GLib.DateMonth.JANUARY, 2000))
    EOS

    pythons.each do |python|
      system python, "test.py"
    end
  end
end
