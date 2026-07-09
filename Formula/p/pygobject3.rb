class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://pygobject.gnome.org"
  url "https://download.gnome.org/sources/pygobject/3.56/pygobject-3.56.3.tar.gz"
  sha256 "12760e4a0e3d04b6eb95e06f7a27e362c826d567ea613373a92c003b6c70d2d6"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "af515b8c8be1f1e224ca0e669d330f9c926e6b9b3b0d5c3106688dc01398e94b"
    sha256 cellar: :any, arm64_sequoia: "b01dae5887bfcd70d47ae83a8f22fe852e42029d244de447dc045398e3016f63"
    sha256 cellar: :any, arm64_sonoma:  "dfc6ce7cc1daf8b5ff21fddc076a44f5cd55b27248adc4150f8978b8646215e6"
    sha256 cellar: :any, sonoma:        "fe7694cb7e11b373bd8f20f7268a9123a87f46b2534b2a1693aa63fbefd65008"
    sha256               arm64_linux:   "258da626c89c4b0f64c2eb37b63eaf91926c8467dfaacbdb1ab9c054d42abe36"
    sha256               x86_64_linux:  "5b6e90a45e8c613564b13141b56dd8a0cc79ea4c3b28f1c9d4d4dec462df7f46"
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
