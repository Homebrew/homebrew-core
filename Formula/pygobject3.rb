class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://live.gnome.org/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.28/pygobject-3.28.3.tar.xz"
  sha256 "3dd3e21015d06e00482ea665fc1733b77e754a6ab656a5db5d7f7bfaf31ad0b0"
  revision 1

  bottle do
    cellar :any
    sha256 "47aa7d49c32d6805573f84732d9f0a1ff2d88547493b0d7ee2eaa09bdeacbdcb" => :high_sierra
    sha256 "c667c8ad161a8c3a3b86eeb7e74a499d3d0208b216a104211b5714f590525d7c" => :sierra
    sha256 "d9a345b4bda8c9f669377486bd661332a5ece0e9cc429f59189356167733584b" => :el_capitan
  end

  option "without-python", "Build without python3 support"
  option "with-python@2", "Build with python2 support"

  depends_on "pkg-config" => :build
  depends_on "libffi" => :optional
  depends_on "glib"
  depends_on "python@2" => :optional
  depends_on "python" => :recommended
  depends_on "py2cairo" if build.with? "python@2"
  depends_on "py3cairo" if build.with? "python"
  depends_on "gobject-introspection"

  def install
    Language::Python.each_python(build) do |python, _version|
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "PYTHON=#{python}"
      system "make", "install"
      system "make", "clean"
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
