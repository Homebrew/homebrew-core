class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://wiki.gnome.org/Projects/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.30/pygobject-3.30.2.tar.xz"
  sha256 "a4fc3523c4c1bb3d59e01d182fa50d9fb17db9896d86e68e470468390827ed97"

  bottle do
    sha256 "24705830cc11cc4c18f848a537073503087e9ddd0a205ee1a766838140339cbc" => :mojave
    sha256 "06710883fbed3b9f82ec13f063cc3cc4d44cdc6a7bd5096d9e7f29c6d704127b" => :high_sierra
    sha256 "fa2dc4dd4255291ba7a423bdc358b2697bfa847ec248ccea08d8faf1db64ee36" => :sierra
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
