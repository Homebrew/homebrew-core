class Py3gobject3 < Formula
  desc "GNOME Python3 bindings (based on GObject Introspection)"
  homepage "https://live.gnome.org/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.26/pygobject-3.26.0.tar.xz"
  sha256 "7411acd600c8cb6f00d2125afa23303f2104e59b83e0a4963288dbecc3b029fa"

  depends_on "pkg-config" => :build
  depends_on "libffi" => :optional
  depends_on "glib"
  depends_on :python3
  depends_on "py3cairo"
  depends_on "gobject-introspection"

  def install
    system "python3", *Language::Python.setup_install_args(prefix)
  end

  test do
    Pathname("test.py").write <<-EOS.undent
    import gi
    assert("__init__" in gi.__file__)
    EOS
    # ENV.prepend_path "PYTHONPATH", lib/"python#{pyversion}/site-packages"
    system "python3", "test.py"
  end
end
