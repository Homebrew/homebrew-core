class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://wiki.gnome.org/Projects/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.30/pygobject-3.30.1.tar.xz"
  sha256 "e1335b70e36885bf1ae207ec1283a369b8fc3e080688046c1edb5a676edc11ce"

  bottle do
    sha256 "d2f915f9926b904ca20f3976c003be9f777403f4f0ac76646c6c410990a34285" => :mojave
    sha256 "4d929370081936dfebf95767696c62be500c1e3197ee38d1b6cc6468f432daca" => :high_sierra
    sha256 "9c9c97adeff1513f3f14f84dc6d1f17aea83dc322efea5c3733603e18b246947" => :sierra
    sha256 "61a4cb205453ebb9c2e9bc1c9c92d7a93fb26b7886c94a7e03406c7f1541a72a" => :el_capitan
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
