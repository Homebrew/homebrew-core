class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://wiki.gnome.org/Projects/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.32/pygobject-3.32.1.tar.xz"
  sha256 "32c99def94b8dea5ce9e4bc99576ef87591ea779b4db77cfdca7af81b76d04d8"

  bottle do
    cellar :any
    sha256 "592c5c45eb5e6001d87faa4a287c9fcadc296a91024eee7da39f318f8940409c" => :mojave
    sha256 "9022c03bcfdb461d23733b4ec04fcf7d470d3cb64c6aa847b8c795992f3977c6" => :high_sierra
    sha256 "d645dba8e9857d2059e60209d72db20d5efa486869a4321dadb1fd11cfa8c8ee" => :sierra
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
