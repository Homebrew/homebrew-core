class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://wiki.gnome.org/Projects/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.36/pygobject-3.36.0.tar.xz"
  sha256 "8683d2dfb5baa9e501a9a64eeba5c2c1117eadb781ab1cd7a9d255834af6daef"

  bottle do
    cellar :any
    sha256 "63c1f6a01fd1d27a252cdeabdd0e084598ec9b79eb05a523e48f7f13c4f05746" => :catalina
    sha256 "9b3863938691e7992ed55d37837a30f6bc851f0af1444d4eb32b735f4a1b10c8" => :mojave
    sha256 "f2cdd475ed9816f815bb1d6874780df09b82d3f925b2571a4567ee90ab89a073" => :high_sierra
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
