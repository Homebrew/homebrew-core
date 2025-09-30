class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://pygobject.gnome.org"
  url "https://download.gnome.org/sources/pygobject/3.54/pygobject-3.54.3.tar.gz"
  sha256 "a8da09134a0f7d56491cf2412145e35aa74e91d760e8f337096a1cda0b92bae7"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ec1a61f1af16d64db9bc4ee3685d30736572bc5296a876b343f2a0701fa93856"
    sha256 cellar: :any, arm64_sequoia: "25661b3cb0bc9eb486eac13541d40e829edbd7bc7b09242ab98329726d774cac"
    sha256 cellar: :any, arm64_sonoma:  "8693f65ff672351e87e7cb1a62ee1cecba638567567c7951c66e59f668d89ef3"
    sha256 cellar: :any, sonoma:        "e2a6b171d8cd3be641d517f308fcddaf745e7fc2cc25b2d15402948944216c98"
    sha256               arm64_linux:   "81eecf4580130e10f5206ab5c2c138e87a7eacd1fe3022ace196815110455750"
    sha256               x86_64_linux:  "e71432f52934f2705f611430bfdeeee421ab24a43d5c3f676606e32402d8b5c1"
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
