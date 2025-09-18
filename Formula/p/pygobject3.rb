class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://pygobject.gnome.org"
  url "https://download.gnome.org/sources/pygobject/3.54/pygobject-3.54.2.tar.gz"
  sha256 "03cffeb49d8a1879b621d8f606ac904218019a0ae699b1cd3780a8ee611e696b"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "970a4ceed8fffde9b35b70c3c7ab3c7e861a4c72df0042f52a0f5529e7cbbbc2"
    sha256 cellar: :any, arm64_sequoia: "c04676b8d1aae19fe444de46e21a769af3e804865e6cf948dbb75d3a57f479b6"
    sha256 cellar: :any, arm64_sonoma:  "6463a7d8e9351c409f4536d4e7aafcc96d4c3182c41806cd225c4625e92cd183"
    sha256 cellar: :any, sonoma:        "9499ec0de1010af97aafdd7e21dee4fe05620df0bb33f93d82c2625a30acb7f1"
    sha256               arm64_linux:   "1f672715b02517135e4688c1b240fa5a1891c7f8d433e3184287356901b80ae3"
    sha256               x86_64_linux:  "412eb417f1718561322d44c3da2b3b0699a28d8d4a601278460666e37b0ae8e2"
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
