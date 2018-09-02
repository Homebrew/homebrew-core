class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://wiki.gnome.org/Projects/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.30/pygobject-3.30.0.tar.xz"
  sha256 "7d20ba1475df922f4c26c69274ab89f7e7730d2101e46846caaddc53afd56bd0"

  bottle do
    cellar :any
    sha256 "fda3dbf39e910b3c48b71fb8651231e9acb9fb8509199132e4a3398d88f3a399" => :mojave
    sha256 "47aa7d49c32d6805573f84732d9f0a1ff2d88547493b0d7ee2eaa09bdeacbdcb" => :high_sierra
    sha256 "c667c8ad161a8c3a3b86eeb7e74a499d3d0208b216a104211b5714f590525d7c" => :sierra
    sha256 "d9a345b4bda8c9f669377486bd661332a5ece0e9cc429f59189356167733584b" => :el_capitan
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

        # avoid linking against python framework
        # reported at https://gitlab.gnome.org/GNOME/pygobject/issues/253
        libs = `pkg-config --libs python-#{version}`.chomp.split
        dylib = libs[0][2..-1] + "/lib" + libs[1][2..-1] + ".dylib"
        inreplace "build.ninja", dylib, ""

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
