class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://live.gnome.org/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.26/pygobject-3.26.0.tar.xz"
  sha256 "7411acd600c8cb6f00d2125afa23303f2104e59b83e0a4963288dbecc3b029fa"

  bottle do
    cellar :any
    sha256 "526dad2d5a56175bce619bf095c953df0c04eb35b98f62899df61515dd1ef89e" => :sierra
    sha256 "8cee61b5ff37a70ce9b5d6d424903c046726f797c618af62c6d2c52e56fd006a" => :el_capitan
    sha256 "5d3c6ec80eb8f41a6735c893ea340c1c4a4c13a2edf137dd40f396b8b8b7fd43" => :yosemite
  end

  option "without-python", "Build without python2 support"

  depends_on "pkg-config" => :build
  depends_on "libffi" => :optional
  depends_on "glib"
  depends_on :python3 => :optional
  depends_on "py2cairo" if build.with? "python"
  depends_on "py3cairo" if build.with? "python3"
  depends_on "gobject-introspection"

  def install
    Language::Python.each_python(build) do |python, _version|
      system python, *Language::Python.setup_install_args(prefix)
    end
  end

  test do
    Pathname("test.py").write <<-EOS.undent
    import gi
    assert("__init__" in gi.__file__)
    EOS
    Language::Python.each_python(build) do |python, pyversion|
      ENV.prepend_path "PYTHONPATH", lib/"python#{pyversion}/site-packages"
      system python, "test.py"
    end
  end
end
