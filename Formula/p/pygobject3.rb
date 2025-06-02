class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://pygobject.gnome.org"
  url "https://download.gnome.org/sources/pygobject/3.52/pygobject-3.52.3.tar.gz"
  sha256 "00e427d291e957462a8fad659a9f9c8be776ff82a8b76bdf402f1eaeec086d82"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "b8d91047912ee452e7b000c29413dc0646134deee82d94181c8063ab5f33fd70"
    sha256 cellar: :any, arm64_sonoma:  "def6801a1a2cda4fa6873130411bbd3c5a57cfc8027ede2aed8b557d2932b1a0"
    sha256 cellar: :any, arm64_ventura: "45ccc44e5d04c45b4019c3669bb2faf7348b417fd1e3da58f24c4cf19ef86538"
    sha256 cellar: :any, sonoma:        "87b3fe1cbb732c37d112c4a24acebd29a778836cf3360f3dfb356d6d0c561885"
    sha256 cellar: :any, ventura:       "bfd291c8f04e022750b169ca41f2976ed9980b99e65e22cd0dcedcf484702bc9"
    sha256               arm64_linux:   "e2bccaf4b84f7b54193c369b6ea4a738e6343ddf3498e5a26f69dda3db59e0a5"
    sha256               x86_64_linux:  "0367b4bfcc0e178c788629172392956f88494ab1e04577b092b53eaf5b008a60"
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
