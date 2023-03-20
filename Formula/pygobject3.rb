class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://wiki.gnome.org/Projects/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.44/pygobject-3.44.0.tar.xz"
  sha256 "f6863d6a3b70d9ace4c36a9901d39e42c8801d11309ca2a8b3459d1c24e34b7f"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "f364142eb07f0b08693a533a844561acd1bc6afde3b8f11942ee56c1c9b16e67"
    sha256 cellar: :any, arm64_monterey: "c90847d79f343c1f28432ceee1cf451b8096a70c8bcdf3ea2f024c7a47e59c5a"
    sha256 cellar: :any, arm64_big_sur:  "0bec84c93e3b8b6553fd7de801946b8e919ebb8d786777fb1d9051c2fbeb3bfd"
    sha256 cellar: :any, ventura:        "066ab58a4de77d34f5af7bd9a0baa1f49998539db7d57ed13886cea6117138e3"
    sha256 cellar: :any, monterey:       "ac6c4fe10c35185d7e435e7425dfb80be5d3eb70b7ee323c21b1fdca1568bd8d"
    sha256 cellar: :any, big_sur:        "6f6a4c7b37f16c4251564aae6daceae8558cba56cb2f213625070f09e8ce4a8d"
    sha256               x86_64_linux:   "f0f95b49bb5b9ae4d7598e2e4748d28f698acf5dda201bcec77ae2d2495af44f"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
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
