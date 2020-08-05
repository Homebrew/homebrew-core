class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://wiki.gnome.org/Projects/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.36/pygobject-3.36.1.tar.xz"
  sha256 "d1bf42802d1cec113b5adaa0e7bf7f3745b44521dc2163588d276d5cd61d718f"

  bottle do
    cellar :any
    sha256 "174079a381809080c02d5720bc2538929bf571d28710f7ab3cb646bfcd2a5bbf" => :catalina
    sha256 "c2b276445ce99b5094cd6b68b03fb6dc47a8c2eefbc743b40eacc373b822345c" => :mojave
    sha256 "f462700d1cd736cc800d410ef3e4d2509527ca98cb7dc437ac80adb9bc04b6d6" => :high_sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gobject-introspection"
  depends_on "py3cairo"
  depends_on "python@3.8"

  def install
    mkdir "buildpy3" do
      system "meson", *std_meson_args,
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
