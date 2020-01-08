class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://wiki.gnome.org/Projects/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.34/pygobject-3.34.0.tar.xz"
  sha256 "87e2c9aa785f352ef111dcc5f63df9b85cf6e05e52ff04f803ffbebdacf5271a"

  bottle do
    cellar :any
    rebuild 1
    sha256 "19438d4f683d7c240842f9ae4793ac7628b2e412e1fc9ece7f11bb7ae6cfa2a1" => :catalina
    sha256 "bc8b4c3b891a179d532e2ef4352d6c6f767472d37f2d800ce2042c83b11c482f" => :mojave
    sha256 "7c7b94ec1114c60af7d943b3d5230b1986515a6eeb057905940711084b43d14b" => :high_sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gobject-introspection"
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
