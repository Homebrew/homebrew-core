class Py2gobject3 < Formula
  desc "GNOME Python2 bindings (based on GObject Introspection)"
  homepage "https://live.gnome.org/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.26/pygobject-3.26.0.tar.xz"
  sha256 "7411acd600c8cb6f00d2125afa23303f2104e59b83e0a4963288dbecc3b029fa"

  bottle do
    cellar :any
    sha256 "33baed6f8f429ce30f19a8a02d8c9c16ed82bcfc9f1a10a96545092b5c5e5245" => :high_sierra
    sha256 "af9b369423638e8fc2e31c6d777cb284886ac21fac08edad6823050a010ad09c" => :sierra
    sha256 "223ce7f1ca5c4b93666b50a81efd497551fe05c90f4cc73f6279eac7e733c89e" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libffi" => :optional
  depends_on "glib"
  depends_on "py2cairo"
  depends_on "gobject-introspection"

  def install
    system "python", *Language::Python.setup_install_args(prefix)
  end

  test do
    Pathname("test.py").write <<-EOS.undent
    import gi
    assert("__init__" in gi.__file__)
    EOS
    # ENV.prepend_path "PYTHONPATH", lib/"python#{pyversion}/site-packages"
    system "python", "test.py"
  end
end
