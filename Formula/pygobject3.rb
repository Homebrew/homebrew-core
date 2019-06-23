class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://wiki.gnome.org/Projects/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.32/pygobject-3.32.2.tar.xz"
  sha256 "c39ca2a28364b57fa00549c6e836346031e6b886c3ceabfd8ab4b4fed0a83611"

  bottle do
    cellar :any
    sha256 "cf2738f0f61ac488ac4b2a67f10c2740b3249728e807b5169c531d14357f08de" => :mojave
    sha256 "ab1cde8cc940917da59401934c8f3a0b3f65c41efc8fdb02816a9bc3f668b91a" => :high_sierra
    sha256 "7b8c52ed0c05cefe12583337129192fa21aba265ad88bc16c8ef4316655cf713" => :sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gobject-introspection"
  depends_on "py2cairo"
  depends_on "py3cairo"
  depends_on "python"
  depends_on "python@2"

  def install
    mkdir "buildpy2" do
      system "meson", "--prefix=#{prefix}",
                      "-Dpycairo=true",
                      "-Dpython=python2.7",
                      ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end

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
    pythons = [
      Formula["python@2"].opt_bin/"python2",
      Formula["python"].opt_bin/"python3",
    ]
    pythons.each do |python|
      pyversion = Language::Python.major_minor_version(python)
      ENV.prepend_path "PYTHONPATH", lib/"python#{pyversion}/site-packages"
      system python, "test.py"
    end
  end
end
