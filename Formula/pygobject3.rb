class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://wiki.gnome.org/Projects/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.42/pygobject-3.42.0.tar.xz"
  sha256 "9b12616e32cfc792f9dc841d9c472a41a35b85ba67d3a6eb427e307a6fe4367b"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_big_sur: "b88e26771ff3a798d0fd4d6046740464031ca7da1f0644cf7993c88cfd4f1154"
    sha256 cellar: :any, big_sur:       "0113cf46c25b6d42fa83dadf97fa696963831dc1695a3561da2c8df25910bf6a"
    sha256 cellar: :any, catalina:      "08f34eba1892e4b0f9b7471bba718acd5f860afdb3de7694f37fb6d77e73d849"
    sha256 cellar: :any, mojave:        "fde6fafd1ede8023cf0f0481d5912258610a82a4c97650864fa1c88119a06a43"
    sha256               x86_64_linux:  "e12a37ac040cb49aa802f1a34d322fd6835b0bb62b3b8c10fbfcae8000b1a2da"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gobject-introspection"
  depends_on "py3cairo"
  depends_on "python@3.9"

  def install
    mkdir "buildpy3" do
      system "meson", *std_meson_args,
                      "-Dpycairo=enabled",
                      "-Dpython=#{Formula["python@3.9"].opt_bin}/python3",
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

    pyversion = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    ENV.prepend_path "PYTHONPATH", lib/"python#{pyversion}/site-packages"
    system Formula["python@3.9"].opt_bin/"python3", "test.py"
  end
end
