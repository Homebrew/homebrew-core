class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://wiki.gnome.org/Projects/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.32/pygobject-3.32.2.tar.xz"
  sha256 "c39ca2a28364b57fa00549c6e836346031e6b886c3ceabfd8ab4b4fed0a83611"
  revision 1

  bottle do
    cellar :any
    sha256 "4ac8bdd6ceb94486ee57b02fcd8f5f76e244a58101cb501d18d104f1b705e9da" => :mojave
    sha256 "ac2f4323d893c76ad1490e25ab35764ff0deec56c94586e648e2f0b889dfcdd6" => :high_sierra
    sha256 "15e8e07f5f0be89e6e85886400202347c4e4d00b2b76a8733f8cce16c490c9d8" => :sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gobject-introspection"
  depends_on "py2cairo"
  depends_on "py3cairo"
  depends_on "python"

  def install
    mkdir "buildpy3" do
      system "meson", "--prefix=#{prefix}",
                      "-Dpycairo=true",
                      "-Dpython=python3",
                      ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
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

    pyversion = Language::Python.major_minor_version "python3"
    ENV.prepend_path "PYTHONPATH", lib/"python#{pyversion}/site-packages"
    system "python3", "test.py"
  end
end
