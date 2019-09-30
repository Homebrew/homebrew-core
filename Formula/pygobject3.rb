class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://wiki.gnome.org/Projects/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.34/pygobject-3.34.0.tar.xz"
  sha256 "87e2c9aa785f352ef111dcc5f63df9b85cf6e05e52ff04f803ffbebdacf5271a"

  bottle do
    cellar :any
    sha256 "5ab85d008b95eea80afc8f7991e044ffa85104fe1d3dbf0ef6adf52caa8d7b37" => :catalina
    sha256 "10abeaee530ca25b234c317adf3d46524beb878ede16d7100322c1c1aded878d" => :mojave
    sha256 "be14c63aab1bdc4bb3abd6078c5dce50c5fea09f5bf71b2425bee33bee038242" => :high_sierra
    sha256 "1a7b76f2f40d02ca4c5ddfc8ded2f8f2362f900493e243b2b08ec856b0d42c48" => :sierra
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
