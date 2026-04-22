class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://pygobject.gnome.org"
  url "https://download.gnome.org/sources/pygobject/3.56/pygobject-3.56.2.tar.gz"
  sha256 "b816098969544081de9eecedb94ad6ac59c77e4d571fe7051f18bebcec074313"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "38a1fc2698ef7c37e2c09ef375b61632c7e82e3a76406aa37f1e30a2bbddccd9"
    sha256 cellar: :any, arm64_sequoia: "0047b26bb71b87148c47d25a37d9d00abf033ba6d81972079b97999b5068fd24"
    sha256 cellar: :any, arm64_sonoma:  "24b45d142d54a702e31e2bf66a1f224f4a6556eae782a1ff72f0b74f485a08bc"
    sha256 cellar: :any, sonoma:        "061eb3996225d64ac6f8c031371f6312652c6e88cc1fc4a34f18645c56352d3a"
    sha256               arm64_linux:   "d11e7a095f3ad8ffc41750c7c309de342817587263c3564dbcaca68aa2e444d0"
    sha256               x86_64_linux:  "1679fb8090d6ea3fa4edecde7a8a7746eb32acf6855365b42fb8450722e3b898"
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
