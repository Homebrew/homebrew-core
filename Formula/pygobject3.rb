class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://wiki.gnome.org/Projects/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.30/pygobject-3.30.4.tar.xz"
  sha256 "2dc1a1a444b82955e65b81c2a2511ecf8032404beba4ef1d48144168f2f64c43"

  bottle do
    sha256 "503f1e5c002d4456411b4108affd9bdb4e6161ca675f5ea659a87fd3e184f6b2" => :mojave
    sha256 "18644e31d16bf1b548f265d11a12f4cfcb771d501f26e5a1b9e045d113ddf956" => :high_sierra
    sha256 "86f464cc9a5f28088567658d1463431444127c6333a2973c373181895bf53e9d" => :sierra
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
