class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://pygobject.gnome.org"
  url "https://download.gnome.org/sources/pygobject/3.58/pygobject-3.58.0.tar.gz"
  sha256 "45068697de3ffe46840ca369705f23118b34db4f7deb63f6eff079a6734ddcca"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f39c1039804c10a3fbf17b6118a13810904e86eade5e5ab79731f7703417205e"
    sha256 cellar: :any, arm64_tahoe:       "e0cea8a3c19efd7f42aeafcb4984c91021d32ec33236026fa0076188d387bce8"
    sha256 cellar: :any, arm64_sequoia:     "c74b6b2e15dacaf078d61343744a187b1314cac236d400ee3a2919e5a5ea80ba"
    sha256 cellar: :any, arm64_sonoma:      "951312ab397caff435a557403b8a3df7729e975ed607374953a1ed2049ea5e42"
    sha256 cellar: :any, arm64_linux:       "b6585e7540b17a48d30f88fcc9544cf5b5b2d1586a9ed3cc9069f90810c76876"
    sha256 cellar: :any, x86_64_linux:      "47da6e2a9f3449014a5d741fb7758443fa0a353d5c309395eff5e33f720774ec"
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
