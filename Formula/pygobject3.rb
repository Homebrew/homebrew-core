class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://wiki.gnome.org/Projects/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.36/pygobject-3.36.0.tar.xz"
  sha256 "8683d2dfb5baa9e501a9a64eeba5c2c1117eadb781ab1cd7a9d255834af6daef"
  revision 2

  bottle do
    cellar :any
    sha256 "075757fd61db80931583784a9c277bf02639995a4ed9c3773ff8cc7576d64b80" => :catalina
    sha256 "bb6c6e6116e560a190e2d5e68d1b70d23351fe6c431ffeaaacf87df00651e8f2" => :mojave
    sha256 "99ac464e907ad4e5afd6982d661b44723ec73e77257cca034e0eb654d2b99a4b" => :high_sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gobject-introspection"
  depends_on "py3cairo"
  depends_on "python@3.8"

  def install
    mkdir "buildpy3" do
      system "meson", "--prefix=#{prefix}",
                      "-Dpycairo=true",
                      "-Dpython=#{Formula["python@3.8"].opt_bin}/python3",
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

    pyversion = Language::Python.major_minor_version Formula["python@3.8"].opt_bin/"python3"
    ENV.prepend_path "PYTHONPATH", lib/"python#{pyversion}/site-packages"
    system Formula["python@3.8"].opt_bin/"python3", "test.py"
  end
end
