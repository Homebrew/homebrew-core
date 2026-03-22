class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://pygobject.gnome.org"
  url "https://download.gnome.org/sources/pygobject/3.56/pygobject-3.56.1.tar.gz"
  sha256 "2ec1cc8c55c7ffeebb97e58a9bba7aa1e74611f1173628084685446804a8881a"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "71463d786a2c092be821002478ede1418b63816367aa85b63801ff884ef7388e"
    sha256 cellar: :any, arm64_sequoia: "2738ab144fdd30aa615a2ef184683495dda3adceec96cb955d1440cefe004e6a"
    sha256 cellar: :any, arm64_sonoma:  "0842af882d7c66ec1f03f5888afccf018139c95d104cbbe0a733a9ba25e790d2"
    sha256 cellar: :any, sonoma:        "beb1e2b8a01f338cfcd5d46728e7581a1c311550fcdf968d42336e7eefedfac6"
    sha256               arm64_linux:   "7684146c5d4b0522950f88f011293d12495b2643e59b71211cb3cc2fd72231eb"
    sha256               x86_64_linux:  "241f466211a72a45aa16c6a1e616b2c68bf689805defdeb87320c94ed3ad723e"
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
