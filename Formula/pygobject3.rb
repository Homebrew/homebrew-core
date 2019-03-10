class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://wiki.gnome.org/Projects/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.32/pygobject-3.32.0.tar.xz"
  sha256 "83f4d7e59fde6bc6b0d39c5e5208574802f759bc525a4cb8e7265dfcba45ef29"

  bottle do
    cellar :any
    rebuild 1
    sha256 "b2e5a251c6d41ad8b039ea1637c39aabbfa3e055366124c7461f65711e210b68" => :mojave
    sha256 "4ac894ae8761c85bceade1626bd4c7afd1850ad8fceb32cbe2a6a852121a2661" => :high_sierra
    sha256 "b5494a628c4b090acc17a6f7510672ed8e1c9487261bffd386368d1c93f23012" => :sierra
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
      system "ninja", "install"
    end

    mkdir "buildpy3" do
      system "meson", "--prefix=#{prefix}",
                      "-Dpycairo=true",
                      "-Dpython=python3",
                      ".."
      system "ninja", "-v"
      system "ninja", "install"
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
