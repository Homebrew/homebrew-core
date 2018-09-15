class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://wiki.gnome.org/Projects/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.30/pygobject-3.30.1.tar.xz"
  sha256 "e1335b70e36885bf1ae207ec1283a369b8fc3e080688046c1edb5a676edc11ce"

  bottle do
    sha256 "b2dc5ccd1ccb7a27c869edf6b4b8653088457e2fff29c2e83a5771b3284529de" => :mojave
    sha256 "e7cdcda8c8b08569363811da5ddf6453b85975847dd30103181ac4c503d80fde" => :high_sierra
    sha256 "974dc882d220f378dc2ea44a8bff6fa87b020fa48fe049e97cff24defa6cc170" => :sierra
    sha256 "62af7aa4ba704a7b7ea9d55b9d08a7ce9ce787a30f13840523a5c67cf671e3e0" => :el_capitan
  end

  option "without-python", "Build without python3 support"
  option "with-python@2", "Build with python2 support"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => [:build, :recommended]
  depends_on "gobject-introspection"
  depends_on "python@2" => :optional
  depends_on "py2cairo" if build.with? "python@2"
  depends_on "py3cairo" if build.with? "python"

  def install
    Language::Python.each_python(build) do |python, version|
      mkdir "build#{version}" do
        system "meson", "--prefix=#{prefix}",
                        "-Dpycairo=true",
                        "-Dpython=#{python}",
                        ".."
        system "ninja", "-v"
        system "ninja", "install"
      end
    end
  end

  test do
    Pathname("test.py").write <<~EOS
      import gi
      assert("__init__" in gi.__file__)
    EOS
    Language::Python.each_python(build) do |python, pyversion|
      ENV.prepend_path "PYTHONPATH", lib/"python#{pyversion}/site-packages"
      system python, "test.py"
    end
  end
end
