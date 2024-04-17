class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://wiki.gnome.org/Projects/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.48/pygobject-3.48.2.tar.xz"
  sha256 "0794aeb4a9be31a092ac20621b5f54ec280f9185943d328b105cdae6298ad1a7"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "03a66429468af32cc5ca8458dbff8307cf77a6ccb66ce366be318abb71e6dcb7"
    sha256 cellar: :any, arm64_ventura:  "91bddd1d00d2c8c7e50190714c21f35e98c37d5945f23d1bbe9e49035cad8fe5"
    sha256 cellar: :any, arm64_monterey: "6aa5972afb3ac83c880a53bc48d582df92af536f9a616fe40648b3ecd66d2ad7"
    sha256 cellar: :any, sonoma:         "8db6ac23e2664e8a55aa4ef0d360a2150ff7165e6a209fd39eca0898298fdd4c"
    sha256 cellar: :any, ventura:        "7be31857d1eb553331fa404029bf6f510c0ea48b83395b268909a67b3eae20c7"
    sha256 cellar: :any, monterey:       "73c9c2554d086c379912a18614f3870dcf9fbb120e3e63a0ee67736d59eb1eeb"
    sha256               x86_64_linux:   "e619d0cec5375d3427d05b6cac359b993546ead0f78a3b2205f950d012645d7c"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
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
                                         "-Dtests=false",
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
