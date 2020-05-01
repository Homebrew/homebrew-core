class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://wiki.gnome.org/Projects/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.36/pygobject-3.36.0.tar.xz"
  sha256 "8683d2dfb5baa9e501a9a64eeba5c2c1117eadb781ab1cd7a9d255834af6daef"
  revision 2

  bottle do
    cellar :any
    sha256 "2636d93f6867f57a6f2a20f5011e2559a8bcceb65bccfe74870b9377a238adce" => :catalina
    sha256 "3c9b34d60ebfa6bafbcf950690794fbd047b42fdf20614f5178d7460a2c8b5ab" => :mojave
    sha256 "0a39bc5ec20ac0acc646abf385c2eccca9910dc17d1e25342ab34e84f865352d" => :high_sierra
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
