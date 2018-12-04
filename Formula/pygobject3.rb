class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://wiki.gnome.org/Projects/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.30/pygobject-3.30.4.tar.xz"
  sha256 "2dc1a1a444b82955e65b81c2a2511ecf8032404beba4ef1d48144168f2f64c43"

  bottle do
    sha256 "c4004732688326f968423751c18861a21297e36bd628bd19e0c410747d60f07a" => :mojave
    sha256 "342769a9ab3cbb29bd30368cb4ef7024821f45032f185c952dfdc9b32ccb4b39" => :high_sierra
    sha256 "34cb3f702e580475d18bb44652fdcfb02041a1a7153246e2b710df17576b93e4" => :sierra
  end

  option "without-python", "Build without python3 support"
  option "with-python@2", "Build with python2 support"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => [:build, :recommended]
  depends_on "gobject-introspection"
  depends_on "py3cairo" if build.with? "python"
  depends_on "python@2" => :optional
  depends_on "py2cairo" if build.with? "python@2"

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
